class ProfilesController < ApplicationController
  def edit
    @user = User.find(params[:user_id])
    @profile = @user.profile 
    respond_to do |wants|
      wants.html {  }
    end
  end  
  
  def update
    @user = User.find(params[:user_id])
    @profile = @user.profile
    respond_to do |wants|
      if @profile.update_attributes(params[:profile])    
        wants.html { redirect_to @user }
      else
        wants.html { render :action => "edit" } 
      end
    end
  end
end
