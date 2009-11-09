class PostsController < ApplicationController      
  before_filter :login_required,:except => [:index,:show]  

  uses_tiny_mce :only => [:new, :create, :edit, :update,:show],
  :options => { :theme => 'advanced',:content_css => "/stylesheets/editor_content.css",
  :plugins => %w{ syntaxhl },:theme_advanced_buttons1 => 
    "bold,italic,underline,undo,redo,link,unlink,image,forecolor,styleselect,removeformat,cleanup,code, syntaxhl",
    :theme_advanced_buttons2 => "", 
    :theme_advanced_buttons3 => "", 
    :remove_linebreaks => false,:extended_valid_elements => "textarea[cols|rows|disabled|name|readonly|class]"} 
  
  layout 'group'
  # GET /posts
  # GET /posts.xml
  def index
    @posts = Post.paginate :page => params[:page], :order => 'updated_at DESC'
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show   
    store_location
    @post = Post.find params[:id]
    @page_title = @post.title
    @comments = Comment.paginate :page => params[:page], :order => 'created_at ASC',:conditions => ['commentable_id =? and commentable_type =?',@post.id,'Post']
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
      if @post.update_attributes(params[:post])
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
