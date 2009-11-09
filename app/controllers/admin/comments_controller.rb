class Admin::CommentsController < ApplicationController 
  def destroy
    @comment = Comment.find(params[:id]) 
    @post = @comment.commentable
    @comment.destroy    
    
    respond_to do |wants|
      flash[:notice] = "评论已删除"
      wants.html { redirect_to @post }
    end
    
  end
  
end
