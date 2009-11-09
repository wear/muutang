class Admin::PostsController < ApplicationController
  before_filter :login_required
  access_control :DEFAULT => '(superuser | editor)'
     
  def index

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
  
end
