class Admin::CategoriesController < ApplicationController
  def index
    @categories = Category.find(:all)
    @category = Category.new
  end   
  
  def create 
    @categories = Category.find(:all)
    @category = Category.new(params[:category])
    
    respond_to do |wants|
      if @category.save 
        wants.html { redirect_to :action => "index" }
      else
        wants.html { render :action => "index" }
      end
    end
  end       
  
  
end
