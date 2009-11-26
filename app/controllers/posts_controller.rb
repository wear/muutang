class PostsController < ApplicationController      
  before_filter :login_required,:except => [:index,:show]       
  before_filter { |c| c.set_section('bbs') }

  uses_tiny_mce :only => [:new, :create, :edit, :update], 
  :options => TINYIMC                                        
  
  caches_page :index,:show
  cache_sweeper :post_sweeper,:only => [:create,:update,:destroy]
  
  layout 'group'
  # GET /posts
  # GET /posts.xml
  def index                               
    @posts = Post.recent_without_top.paginate(:page => params[:page])
    
    respond_to do |format|
      format.html {  }      
      if params[:page].nil?
        format.js { render :partial => "posts" }
      else
        format.js { }  
      end
      format.xml  { render :xml => @tops }
      format.rss
    end
  end   
  
  def recommand   
    @post = Post.new
    
    respond_to do |wants|
      wants.html { render :layout => 'application' }
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
