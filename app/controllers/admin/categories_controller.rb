class Admin::CategoriesController < ApplicationController   
  before_filter :login_required
  access_control :DEFAULT => '(superuser | editor)'
  
  def index
    @categories = Category.ordered
    @category = Category.new
  end  
  
  def edit
    @category = Category.find(params[:id])
    respond_to do |wants|
      wants.html {  }
    end
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
  
  def update
    @category = Category.find(params[:id])    
    
    respond_to do |wants|
      if @category.update_attributes(params[:category])
        wants.html { redirect_to admin_categories_path }
      else
        wants.html { render :action => "edit" }
      end
    end
  end    
  
  def sort
    params[:categories].each_with_index do |id, index|
      Category.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end

  
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    
    respond_to do |wants|
        wants.html { redirect_to admin_categories_path }
    end
  end     
  
  
end
