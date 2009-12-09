class EventsController < ApplicationController   
  before_filter { |c| c.set_section('events') } 
  uses_tiny_mce :only => [:new, :create, :edit, :update], 
  :options => TINYIMC                      
  layout 'group'
  
  def index  
    @events = Event.find(:all)
  end

  def show    
    @event = Event.find(params[:id])
    respond_to do |wants|
      wants.html {  }
    end
  end   
  
  def preview
    @event = Event.find(params[:id]) 
    respond_to do |wants|
      wants.html { render :layout => "event" }
    end
  end
  
  def open
    @event = Event.find(params[:id])
    @event.open!
    
    respond_to do |wants|            
      flash[:notice] = '活动已发布'
      wants.html { redirect_to @event }
    end
  end  
  
  def close
    @event = Event.find(params[:id])
    @event.close!
    
    respond_to do |wants|            
      flash[:notice] = '活动已结束'
      wants.html { redirect_to events_path }
    end    
  end

  def new 
    @event = Event.new
  end    
  
  def register
    @event = Event.find(params[:id])  
    @form = @event.build_form
    respond_to do |wants|
      wants.html {  }
    end
  end

  def edit  
    @event = Event.find(params[:id])  
  end  
  
  def update
    @event = Event.find(params[:id]) 
    respond_to do |wants|
      if @event.update_attributes(params[:event])  
        flash[:notice] = '修改成功!'
        wants.html { redirect_to @event }
      else
        wants.html  { render :action => "edit"}
      end
    end
  end    
  
  def on_going
    
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
  
  def destroy
    @event = Event.find(params[:id]) 
    @event.destroy     
    
    respond_to do |wants|  
      wants.html { redirect_to events_path }
    end
  end

end
