# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password    
  include AuthenticatedSystem     
  include ExceptionNotifiable  
  
  
  def set_section(section)
    @section = section
  end
  
  def ajax?
    redirect_to(root_path)  unless request.xhr? 
  end        

  
end
