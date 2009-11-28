class Admin::PagesController < ApplicationController 
  layout 'admin'
  before_filter :login_required
  access_control :DEFAULT => '(superuser | editor)'   
  before_filter { |c| c.set_section('cms') } 
  uses_tiny_mce :only => [:new, :create, :edit, :update], 
  :options => ADVTINYIMC 
  
  def index
    @pages = Page.cates
  end   
  
  def new
    @page = Page.new
  end  
  
  def edit
    @page = Page.find(params[:id])
  end  
  
  def update
    @page = Page.find(params[:id])
    
    respond_to do |wants|
      if @page.update_attributes(params[:page])  
        flash[:notice] = '修改成功'
        wants.html { redirect_to :action => "index" }
      else
        wants.html { render :action => "new"}
      end
    end
  end          
  
  def create
    @page = Page.new(params[:page]) 
    respond_to do |wants|
      if @page.save
        wants.html { redirect_to :action => "index" }
      else
        wants.html { render :action => "new" } 
      end
    end
  end
  
  def sort
    params[:pages].each_with_index do |id, index|
      Page.update_all(['position = ?', index+1], ['id=?', id])
    end
    render :nothing => true
  end
  
end
