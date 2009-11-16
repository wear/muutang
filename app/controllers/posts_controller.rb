class PostsController < ApplicationController      
  before_filter :login_required,:except => [:index,:show]  

  uses_tiny_mce :only => [:new, :create, :edit, :update,:show],
  :options => { :theme => 'advanced',:plugins => %w{ syntaxhl },:content_css => "/stylesheets/editor_content.css",
  :browsers => %w{msie gecko safari},
  :theme_advanced_layout_manager => "SimpleLayout",
  :theme_advanced_statusbar_location => "bottom",
  :theme_advanced_toolbar_location => "top",
  :theme_advanced_toolbar_align => "left",
  :theme_advanced_resizing => true,
  :relative_urls => false,
  :convert_urls => false,
  :cleanup => true,
  :cleanup_on_startup => true,  
  :convert_fonts_to_spans => true,
  :theme_advanced_resize_horizontal => false,
  :theme_advanced_buttons1 => %w{bold italic underline separator justifyleft justifycenter justifyright indent outdent separator bullist numlist separator link unlink image media separator  undo redo syntaxhl},
  :theme_advanced_buttons2 => [],
  :theme_advanced_buttons3 => [],
  :editor_deselector => "mceNoEditor"
  } 
    
  caches_page :index,:show
  cache_sweeper :post_sweeper,:only => [:create,:update,:destroy]
  
  layout 'group'
  # GET /posts
  # GET /posts.xml
  def index
    @tops = Post.tops
    @posts =  @tops + Post.recent_without_top
    
    respond_to do |format|
      format.html # index.html.erb   
      format.js { render :partial => "post", :collection => @posts }
      format.xml  { render :xml => @tops }
      format.rss
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show   
    store_location
    @post = Post.find params[:id]
    @page_title = @post.title
    @comments = Comment.paginate :page => params[:page], :order => 'created_at ASC',
                :conditions => ['commentable_id =? and commentable_type =?',@post.id,'Post'],:include => :user
    @comment = @post.comments.new
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = current_user.posts.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = current_user.posts.new(params[:post])

    respond_to do |format|
      if @post.save
        flash[:notice] = '发贴成功!.'
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = current_user.posts.find(params[:id])

    respond_to do |format|
      if @post.editable? && @post.update_attributes(params[:post])
        flash[:notice] = '帖子更新成功.'
        format.html { redirect_to(@post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end   
  
end
