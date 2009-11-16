class LandingController < ApplicationController     
  layout 'group' 
  caches_page :index,:intro
  
  def index  
    @category = Category.ordered.first
    
    respond_to do |wants|
      wants.html {  }
    end
  end   
  
  def intro      
    respond_to do |wants|
      wants.html {  }
    end
  end     

  
end
