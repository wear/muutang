class LandingController < ApplicationController     
  
  caches_page :index,:intro,:faq,:about
  
  def index  
    @category = Category.ordered.first
    
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
    respond_to do |wants|
      wants.html {  }
    end
    
  end
         
  def about
    respond_to do |wants|
      wants.html {  }
    end
    
  end
  
end
