class Admin::UsersController < ApplicationController    
  before_filter :login_required
  access_control :DEFAULT => '(superuser)'
  before_filter :find_role,:only => [:update_role,:destroy_role]
  
  def index
     @users = User.paginate :page => params[:page], :order => 'posts_count ASC'   
  end     
  
  def setting_role
    @user = User.find(params[:id])
  end   
  
  def update_role
         
    unless @user.roles.include?(@role)
      @user.roles << @role
    end
    
    respond_to do |wants|        
      flash[:notice] = '更新成功!'
      wants.html { redirect_to setting_role_admin_user_path(@user) }
    end
  end 
  
  def destroy_role 
    @roles = @user.roles
    @roles.each do |r|
      @roles.delete(r) if r.title == @role.title
    end
    
    respond_to do |wants|
      flash[:notice] = '更新成功!'  
      wants.html { redirect_to setting_role_admin_user_path(@user) }
    end
  end 
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy 
    
    respond_to do |wants|
      wants.html { redirect_to admin_users_path }
    end
  end
  
  protected 
  
  def find_role 
     @user = User.find(params[:id]) 
     @role = Role.find_by_title(params[:role]) 
  end         
  
end
