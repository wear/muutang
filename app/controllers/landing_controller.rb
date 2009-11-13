class LandingController < ApplicationController     
  layout 'group' 
  caches_page :index,:intro
  
  def index  
    @tops = Post.tops
    @posts =  @tops + Post.recent_without_top
    respond_to do |wants|
      wants.html {  }
    end
  end   
  
  def intro
    respond_to do |wants|
      wants.html {  }
    end
  end     
  
  def import
    #  @user = User.find_by_email('wear21@hotmail.com')
    #  new_password = @user.reset_password
    #  UserMailer.deliver_new_password(@user, new_password) 
      respond_to do |wants|
        wants.html { render :layout => false }
      end
  end
  
  
end
