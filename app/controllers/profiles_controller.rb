class ProfilesController < ApplicationController 
  
  before_filter :find_user 
  before_filter :login_required
  
  def edit
    @profile = @user.profile 
    respond_to do |wants|
      wants.html {  }
    end
  end  
  
  def update
    @profile = @user.profile
    respond_to do |wants|
      if @profile.update_attributes(params[:profile])    
        wants.html { redirect_to @user }
      else
        wants.html { render :action => "edit" } 
      end
    end
  end  
  
  protected
  
  def find_user
    @user = current_user
  end
  
end
