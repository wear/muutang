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
    Attendee.find(:all).each do |attendee|  
      password = User.generate_new_password
      @user = User.new(:email => attendee.email,:login => attendee.name,:password =>password,:password_confirmation => password )
      begin
      if @user.save
        attendee.update_attributes(:initial_pwd => password)
        @user.profile.update_attributes(:name => attendee.name,:website => attendee.website,
                                        :company => attendee.company,
                                        :phone_number => attendee.phone_number,:city => attendee.city,
                                        :state => attendee.state,:country =>  attendee.country,
                                        :desc => attendee.description,
                                        :company_category => attendee.company_category,
                                        :industry => attendee.industry,
                                        :company_size => attendee.company_size,:title => attendee.title,
                                        :work_experience => attendee.work_experience,
                                        :interesting => attendee.interesting)
      end
            rescue 
            end
    end
    respond_to do |wants|
      wants.html { render :layout => false }
    end
  end
  
end
