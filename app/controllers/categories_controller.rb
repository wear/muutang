class CategoriesController < ApplicationController 
   
  before_filter :login_required,:only => [:user_posts,:user_comments]
  layout false          
  before_filter :ajax?
  
  def show   
     @category = Category.find(params[:id])
     @posts = @category.posts.recent_without_top.paginate(:page => params[:page]) 
     respond_to do |wants|
      wants.html {  }       
      if params[:page].nil?
        wants.js { render :partial => "posts/posts" }
      else
        wants.js { render :template => 'posts/index' }
      end
     end
  end 
  
  def user_posts
    @category = 9999 
    @posts = current_user.posts.ordered.paginate(:page => params[:page]) 
       
    respond_to do |wants|
      wants.html {  } 
      if params[:page].nil?
        wants.js { render :partial => "posts/posts" }
      else
        wants.js { render :template => 'posts/index' }
      end
    end
    
  end 
  
  def user_comments
    @category = 1000
    @comments = Comment.for_others(current_user.id).grouped.paginate(:page => params[:page])
       
    respond_to do |wants|
      wants.html {  } 
      if params[:page].nil?
        wants.js { render :partial => "comments/comments" }
      else
        wants.js {  }
      end
    end
  end  
  
        
  
end
