class EventsController < ApplicationController   
  layout 'group'          
  before_filter { |c| c.set_section('events') } 
  uses_tiny_mce :only => [:new, :create, :edit, :update], 
  :options => TINYIMC
  
  def index  
    @events = Event.find(:all)
  end

  def show
  end

  def new 
    @event = Event.new
  end

  def edit
  end
  
  def create
    @event = Event.new(params[:event])
    
    respond_to do |wants|
      if @event.save
        wants.html { redirect_to @event }
      else
        wants.html { render :action => "new" }
      end
    end
  end

end
