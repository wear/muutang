class CategoriesController < ApplicationController     
  layout false 
  
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
  
end
