class Admin::PostsController < ApplicationController   
  layout 'admin'
  before_filter :login_required
  access_control :DEFAULT => '(superuser | editor)'   
  before_filter { |c| c.set_section('manage_post') }  
  before_filter :set_sort_params,:only => [:index]    
  
  uses_tiny_mce :only => [:new, :create, :edit, :update,:show],:options => TINYIMC   
     
  def index         
    @posts = Post.paginate :page => params[:page], :order => params[:sort]
  end     
  
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    
    respond_to do |wants|
      flash[:notice] = "帖子已删除"
      wants.html { redirect_to root_path }
    end    
  end
  
  def set_visibility
    @post = Post.find(params[:id])  
    
    respond_to do |wants|
      if @post.update_attributes(:visible => params[:visible])
        flash[:notice] = '操作成功!'
      else
        flash[:error] = '出错了'
      end
      wants.html { redirect_to @post }    
    end
  end

  def edit
    @post = Post.find(params[:id])  
    
    respond_to do |wants|
      wants.html {  }
    end
  end           
  
  def update
    @post = Post.find(params[:id]) 
    
    respond_to do |wants|  
      if @post.update_attributes(params[:post])   
        flash[:notice] = '帖子修改成功!'
        wants.html { redirect_to admin_posts_path }
      else
        wants.html { render :action => "edit" } 
      end
    end
  end
  
  def marktop
    @post = Post.find(params[:id])
    
    respond_to do |wants|
      if @post.update_attributes(:top => params[:mark_top])
        flash[:notice] = '操作成功!'
      else
        flash[:error] = '出错了'
      end
      wants.html { redirect_to @post }    
    end
  end
  
  protected
  
  def set_sort_params
    params[:sort] = params[:sitem].nil? ? "created_at desc" : "#{params[:sitem].gsub('-',' ')}"
  end                
  
end
