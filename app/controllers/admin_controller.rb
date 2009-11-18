class AdminController < ApplicationController    
  before_filter :login_required
  access_control :DEFAULT => '(superuser)'  

  
  def index
  end
  
  protected

  def permission_denied
    flash[:notice] = "You don't have privileges to access this action"
    return redirect_to('/')
  end

end
