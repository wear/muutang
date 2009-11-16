class CategoriesController < ApplicationController     
  layout false 
  
  def show
     @posts = Category.find(params[:id]).posts.recent_without_top
     respond_to do |wants|
      wants.html {  }
      wants.js { render :partial => "posts/post", :collection => @posts }
     end
  end
end
