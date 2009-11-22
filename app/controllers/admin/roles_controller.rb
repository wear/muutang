class Admin::RolesController < ApplicationController 
  layout 'admin'       
  before_filter :login_required
  access_control :DEFAULT => '(superuser)'    
  before_filter { |c| c.set_section('manage_role') }      
  
  def index
    @roles = Role.find(:all) 
    @role = Role.new
  end     
  
  def create      
    @roles = Role.find(:all)  
    @role = Role.new(params[:role])
    
    respond_to do |wants|
      if @role.save
        wants.html { redirect_to admin_roles_path }
      else 
        wants.html { render :action => "index" }
      end
    end
  end  
  
  def destroy
    @role = Role.find params[:id]
    @role.destroy 
    
    respond_to do |wants|
      wants.html { redirect_to admin_roles_path }
    end
  end

end
