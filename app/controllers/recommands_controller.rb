class RecommandsController < ApplicationController 
  before_filter :login_required,:except => [:index,:show,:hot] 
  before_filter :find_recommand,:only => [:new]
  before_filter { |c| c.set_section('recommands') }
  layout 'group'   
  
  # GET /recommands
  # GET /recommands.xml
  def index   
    @kind = 'all'
    @recommandation = Recommandation.paginate(:page => params[:page],:order => 'created_at DESC')
    
    respond_to do |format|
      format.html # index.html.erb
      format.js { }
    end
  end  
  
  def hot
    @kind = 'hot'
    @recommands = Recommand.paginate(:page => params[:page],:order => 'recommandations_count DESC') 
    
    respond_to do |wants|
      if params[:page].nil?
        wants.js { render :partial => "recommands" }
      else
        wants.js { }
      end
    end
  end    
  
  def own
    @kind = 'own'
    @recommandation = Recommandation.paginate(:page => params[:page],:order => 'created_at DESC',:conditions => ['user_id = ?',current_user.id])
    
    respond_to do |wants|
      if params[:page].nil?
        wants.js { render :partial => "recommandations" }
      else
        wants.js { render :template => 'recommands/index' }
      end
    end
  end

  # GET /recommands/1
  # GET /recommands/1.xml
  def show
    @recommand = Recommand.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @recommand }
    end
  end

  # GET /recommands/new
  # GET /recommands/new.xml
  def new
    respond_to do |format|
      format.html { render :layout => 'application' }
      format.xml  { render :xml => @recommand }
    end
  end 
  
  def new_recommandation   
    @recommandation = Recommandation.new   
    
    respond_to do |wants|
      wants.html { render :layout => 'application' }
    end
  end   
  
  def recommandation       
      @recommand = Recommand.find_by_title(params[:title])
     Recommandation.transaction do 
       @recommandation = Recommandation.new(params[:Recommandation])
       @recommandation.user =  current_user
       @recommandation.recommand = @recommand
       @recommandation.save 
     end
     
    respond_to do |wants|
      if @recommandation.save 
        wants.html { redirect_to recommands_path }
      else     
        flash[:notice] = '出错了,你可能已经评价过此文'
        wants.html { redirect_to recommands_path } 
      end
    end 
       
  end


  # POST /recommands
  # POST /recommands.xml
  def create              
    Recommand.transaction do
      @recommand = Recommand.create(params[:recommand])
      Recommandation.transaction do
        @recommandation = Recommandation.new({:desc => params[:desc]})
        @recommandation.user =  current_user
        @recommandation.recommand = @recommand
        @recommandation.save
      end
    end
    
    respond_to do |format|
      if @recommand.save && @recommandation.save
        flash[:notice] = 'Recommand was successfully created.'
        format.html { redirect_to recommands_path }
        format.xml  { render :xml => @recommand, :status => :created, :location => @recommand }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @recommand.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /recommands/1
  # PUT /recommands/1.xml
  def update
    @recommand = Recommand.find(params[:id])

    respond_to do |format|
      if @recommand.update_attributes(params[:recommand])
        flash[:notice] = 'Recommand was successfully updated.'
        format.html { redirect_to(@recommand) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @recommand.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /recommands/1
  # DELETE /recommands/1.xml
  def destroy
    @recommand = Recommand.find(params[:id])
    @recommand.destroy

    respond_to do |format|
      format.html { redirect_to(recommands_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def find_recommand
    @recommand = Recommand.find_by_title(params[:title]) || Recommand.new 
    redirect_to(new_recommandation_recommands_path(params)) unless @recommand.new_record?   
  end                                                                      
  
end
