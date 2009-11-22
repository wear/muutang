class Admin::UsersController < ApplicationController    
  before_filter :login_required
  access_control :DEFAULT => '(superuser)' 
  before_filter :find_user,:except => [:index,:search]
  before_filter :find_role,:only => [:update_role,:destroy_role]    
  layout 'admin'              
  before_filter { |c| c.set_section('manage_user') }      
  
  def index
     @users = User.paginate :page => params[:page], :order => 'posts_count ASC'   
  end     
       
  def search    
    @column = params[:column]
    @query = params[:query].nil? ? '%' : "#{params[:query]}%" 
    @order = params[:order] || 'created_at'
    @users = User.paginate(:page => params[:page],:conditions => ["#{@column} like ?",@query],:order => "created_at DESC" )  
    respond_to do |wants|
      wants.html { render :action => "index" }
    end                                    
  end   
  
  def edit
     respond_to do |wants|
      wants.html {  }
     end
  end  
  
  def update
    respond_to do |wants|
      if @user.profile.update_attributes(params[:profile]) 
        flash[:notice] = '修改成功!'
        wants.html { redirect_to admin_users_path }
      else
        wants.html { render :action => "edit" }
      end
    end
  end
  
  def setting_role
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
    @user.destroy 
    
    respond_to do |wants|
      wants.html { redirect_to admin_users_path }
    end
  end
  
  protected 
   
  def find_user
     @user = User.find(params[:id],:include => :profile)         
  end           
  
  def find_role 
     @role = Role.find_by_title(params[:role]) 
  end         
  
end
