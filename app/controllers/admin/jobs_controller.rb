class Admin::JobsController < ApplicationController     
  layout 'admin'           
  before_filter :login_required
  before_filter :find_job, :except => [:index]
  access_control :DEFAULT => '(superuser | editor)'  
  before_filter { |c| c.set_section('manage_job') }  
  before_filter :set_sort_params,:only => [:index]  
  
  def index
    @jobs = Job.paginate(:page => params[:page],:order => params[:sort])
  end     
  
  def show
    respond_to do |wants|
      wants.html {  }
    end
  end      
  
  def update
    
    respond_to do |wants|
      if @job.update_atrributes(params[:job]) 
      flash[:notice] = '修改成功'    
      wants.html { redirect_to admin_jobs_path  }
      else
      wants.html { render :action => "edit" }
      end
    end
  end
  
  def edit

  end   
  
  def set_visible

   respond_to do |wants|
     if @job.update_attribute(:visible,params[:visible])
       flash[:notice] = '修改成功'   
       wants.html { redirect_to admin_jobs_path }
     else
       wants.html { render :action => "show" }
     end
   end 
  end
  
  def destroy
    @job.destroy 
    
    respond_to do |wants| 
      flash[:notice] = '已删除'
      wants.html { redirect_to admin_jobs_path }
    end    
  end        

  protected
  
  def find_job
    @job = Job.find(params[:id])
  end
  
  def set_sort_params
    params[:sort] = params[:sitem].nil? ? "created_at desc" : "#{params[:sitem].gsub('-',' ')}"
  end
  
end
