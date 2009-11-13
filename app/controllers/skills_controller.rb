class SkillsController < ApplicationController
  # GET /skills
  # GET /skills.xml     
  before_filter :find_user 
  before_filter :login_required
  
  def index
    @skills = @user.skills

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @skills }
    end
  end

  # GET /skills/1
  # GET /skills/1.xml
  def show
    @skill = @user.skills.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @skill }
    end
  end

  # GET /skills/new
  # GET /skills/new.xml
  def new
    @skill = @user.skills.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @skill }
    end
  end

  # GET /skills/1/edit
  def edit
    @skill = @user.skills.find(params[:id])
  end

  # POST /skills
  # POST /skills.xml
  def create
    @skill = @user.skills.new(params[:skill])

    respond_to do |format|
      if @skill.save
        flash[:notice] = 'Skill was successfully created.'
        format.html { redirect_to(user_skills_path(@user)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /skills/1
  # PUT /skills/1.xml
  def update
    @skill = @user.skills.find(params[:id])

    respond_to do |format|
      if @skill.update_attributes(params[:skill])
        flash[:notice] = 'Skill was successfully updated.'
        format.html { redirect_to(user_skills_path(@user)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /skills/1
  # DELETE /skills/1.xml
  def destroy
    @skill = @user.skills.find(params[:id])
    @skill.destroy

    respond_to do |format|
      format.html { redirect_to(user_skills_url(@user)) }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def find_user
    @user = current_user
  end
  
end
