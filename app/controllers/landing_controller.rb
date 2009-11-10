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
  
end
