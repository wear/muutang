require 'diff'

class WikisController < ApplicationController      
  before_filter :find_wiki
  before_filter :login_required, :except => [:page,:page_list]
  before_filter :find_existing_page, :only => [:rename, :protect, :history, :diff, :annotate, :add_attachment, :destroy]
  layout "group"   
  uses_tiny_mce :options => TINYIMC  
 # helper :attachments
 # include AttachmentsHelper   
  
  # display a page (in editing mode if it doesn't exist)
  def page        
    store_location
    page_title = params[:page]
    @page = @wiki.find_or_new_page(page_title) 
    if @page.new_record?
      if current_user 
        render :action => 'edit'
      else
        render_wiki_missing 
      end
      return
    end
    if params[:version] && current_user
      # Redirects user to the current version if he's not allowed to view previous versions
      redirect_to :version => nil
      return
    end
    @content = @page.content_for_version(params[:version])
    if params[:format] == 'html'
      export = render_to_string :action => 'export', :layout => false
      send_data(export, :type => 'text/html', :filename => "#{@page.title}.html")
      return
    elsif params[:format] == 'txt'
      send_data(@content.text, :type => 'text/plain', :filename => "#{@page.title}.txt")
      return
    end
	  @editable = editable?
	  respond_to do |wants|
	    wants.html { render :action => 'show' }
	    wants.js { render :partial => "wikis/page" } 
	  end
    
  end
  
  
  def create_page
    @page = WikiPage.new(params[:page])
    @content = @page.content_for_version(params[:version])
  end
  
  def new_page
    @page = WikiPage.new
    @content = @page.content_for_version(params[:version])
  end
  
  # edit an existing page or a new one  
  def edit   
    @page = @wiki.find_or_new_page(params[:page])
    @content = @page.content_for_version(params[:version]) 
  end
  
  def update      
      @page = @wiki.find_or_new_page(params[:page])    
      return render_403 unless editable?
       redirect_to :edit unless @page
      @page.content = WikiContent.new(:page => @page) if @page.new_record?

      @content = @page.content_for_version(params[:version])    
      @content.text = 'wiki' if @content.text.blank?
      # don't keep previous comment
      #@content.comments = nil
      if request.get?
        # To prevent StaleObjectError exception when reverting to a previous version
        @content.version = @page.content.version
      else
        if !@page.new_record? && @content.text == params[:content][:text]
          # don't save if text wasn't changed
          redirect_to :action => 'page', :group_id => @group, :page => @page.title
          return
        end
        #@content.text = params[:content][:text]
        #@content.comments = params[:content][:comments]
        @content.attributes = params[:content]
        @content.author = current_user
        # if page is new @page.save will also save content, but not if page isn't a new record
        if (@page.new_record? ? @page.save : @content.save)
          redirect_to :action => 'page', :group_id => @group, :page => @page.title
        else
          render :action => "new_page"
        end
      end
    rescue ActiveRecord::StaleObjectError
      # Optimistic locking exception
      flash[:error] = '此页面处于锁定状态,暂时不能编辑'
      redirect_to page_wiki_path(@group,:page => @page.title)
  end    
  
  # rename a page
  def rename
    return render_403 unless editable?
    @page.redirect_existing_links = true
    # used to display the *original* title if some AR validation errors occur
    @original_title = @page.pretty_title
    if request.post? && @page.update_attributes(params[:wiki_page])
      flash[:notice] = '修改成功!'
      redirect_to :action => 'page', :group_id => @group, :page => @page.title
    end
  end
  
  def protect
    @page.update_attribute :protected, params[:protected]
    redirect_to :action => 'page', :group_id => @group, :page => @page.title
  end

  # show page history
  def history
    @version_count = @page.content.versions.count
    #@version_pages = Wiki.paginate :page => params['p']
    # don't load text    
    @versions = @page.content.versions.paginate :page => params['p'], 
                                            :select => "id, author_id, comments, updated_on, version",
                                            :order => 'version DESC'

    render :layout => false if request.xhr?
  end
  
  def diff
    @diff = @page.diff(params[:version], params[:version_from])
    render_404 unless @diff
  end
  
  def annotate  
    @annotate = @page.annotate(params[:version])     
    render_404 unless @annotate
  end
  
  # remove a wiki page and its history
  def destroy
    return render_403 unless editable?
    @page.destroy
    redirect_to page_wiki_path(:page => 'wiki')
  end

  # display special pages
  def special
    page_title = params[:page].downcase
    case page_title
    # show pages index, sorted by title
    when 'page_index', 'date_index'
      # eager load information about last updates, without loading text
      @pages = @wiki.pages.find :all, :select => "#{WikiPage.table_name}.*, #{WikiContent.table_name}.updated_on",
                                      :joins => "LEFT JOIN #{WikiContent.table_name} ON #{WikiContent.table_name}.page_id = #{WikiPage.table_name}.id",
                                      :order => 'title'
      @pages_by_date = @pages.group_by {|p| p.updated_on.to_date}
      @pages_by_parent_id = @pages.group_by(&:parent_id)
    # export wiki to a single html file
    when 'export'
      @pages = @wiki.pages.find :all, :order => 'title'
      export = render_to_string :action => 'export_multiple', :layout => false
      send_data(export, :type => 'text/html', :filename => "wiki.html")
      return      
    else
      # requested special page doesn't exist, redirect to default page
      redirect_to :action => 'page', :group_id => @group, :page => nil and return
    end
    render :action => "special_#{page_title}"
  end
  
  def preview
    page = @wiki.find_page(params[:page])
    # page is nil when previewing a new page
    return render_403 unless page.nil? || editable?(page)
    if page
      @attachements = page.assets
      @previewed = page.content
    end
    @text = params[:content][:text]
    render :partial => 'shared/preview'
  end

  def add_attachment
    return render_403 unless editable?
    attach_files(@page, params[:attachments])
    redirect_to :action => 'page', :page => @page.title
  end 
  
  def page_list
     respond_to do |wants|
      wants.html {  } 
      wants.js { render :partial => "shared/pages" }
     end
  end

private
  
  def find_wiki  
    @section = 'wiki'
    @group = Group.find(7)
    @wiki = @group.wiki
    render_404 unless @wiki
  rescue ActiveRecord::RecordNotFound
    render_404
  end
  
  # Finds the requested page and returns a 404 error if it doesn't exist
  def find_existing_page
    @page = @wiki.find_page(params[:page])
    render_404 if @page.nil?
  end 
  
  def member?
    true
  end
  
  # Returns true if the current user is allowed to edit the page, otherwise false
  def editable?(page = @page)
    current_user
  end

  # Returns the default content of a new wiki page
  #def initial_page_content(page)
  #  helper = WikiFormatting.helper_for(AppConfig.text_formatting)
  #  extend helper unless self.instance_of?(helper)
  #  helper.instance_method(:initial_page_content).bind(self).call(page)
  #end
end
