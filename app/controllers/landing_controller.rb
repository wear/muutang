class LandingController < ApplicationController     
  
  caches_page :index,:intro,:faq,:about
  
  def index
    @posts = Post.recent_without_top.find(:all,:limit => 5)
    @recommandations = Recommandation.find(:all,:limit => 10,:order => 'created_at DESC')
    @jobs = Job.visible.find(:all,:limit => 5,:order => 'created_at DESC' ) 
    respond_to do |wants|
      wants.html { render :layout => 'group' }
    end
  end   
  
  def intro      
    respond_to do |wants|
      wants.html { render :layout => 'group' }
    end
  end     
  
  def faq    
    @pages = Page.find(:first,:conditions => ['name = ?','帮助'])
  
    respond_to do |wants| 
        wants.html {  }
    end
    
  end
         
  def about 
    @pages = Page.find(:first,:conditions => ['name = ?','关于'])
    respond_to do |wants|
        wants.html {  }
    end
    
  end
  
end
