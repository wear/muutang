class CategoriesController < ApplicationController     
  layout false 
  
  def show   
     @category = Category.find(params[:id])
     @posts = @category.posts.recent.paginate(:page => params[:page], :order => 'top DESC') 
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
