class FormsController < ApplicationController  
  before_filter :find_event  
  layout 'event'
  
  def new   
    @form = @event.build_form 
  end

  def create
    @form = @event.build_form(params[:form])
    respond_to do |wants|
      if @form.save
        wants.html { redirect_to @event }
      else
        wants.html { render :action => "new" } 
      end
    end
  end
  
  protected
  
  def find_event
    @event = Event.find(params[:event_id])
  end

end
