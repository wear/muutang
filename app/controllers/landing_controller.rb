class LandingController < ApplicationController     
  
  def index  
    @tops = Post.tops
    @posts =  @tops + Post.recent_without_top
    respond_to do |wants|
      wants.html { render :layout => 'group' }
    end
  end            
  
end
