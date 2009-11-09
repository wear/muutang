class CommentsController < ApplicationController 
  before_filter :login_required 
  
  def new
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new
    
    respond_to do |wants|
      wants.html {  }
    end
  end    
  
  def create  
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(params[:comment]) 
    @comment.user = current_user
    respond_to do |wants|
      if @comment.save
        @post.update_attribute(:updated_at,@comment.created_at)
        wants.html { redirect_to @post }
      else
        wants.html { render :action => 'new' }
      end
    end
  end     
  
end
