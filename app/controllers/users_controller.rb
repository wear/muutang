class UsersController < ApplicationController 
  
  caches_page :show
  before_filter :login_required,:only => [:change_password,:update_password,:edit,:update]  
  
  auto_complete_for :user,:email    
    
  def show
    @user = User.find(params[:id])
  end    
  
  def change_password
    @user =  current_user
    respond_to do |wants|
      wants.js {  }
    end
  end 

  def update_password
    @user = current_user

    respond_to do |format|
      if User.authenticate(@user.email, params[:user][:current_password])
        unless params[:user][:password].blank?
          if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
            flash[:notice] = "Password updated successfully"
            format.html { redirect_to @user }
          else
            flash[:error] = "Error updating password"
            format.html { render :action => 'change_password' }
          end
        else
            flash[:error] = "New password should not be empty" 
            format.html { render :action => 'change_password' } 
        end
      else
        flash[:error] = 'Incorrect Password'
        format.html { render :action => 'change_password' }
      end
    end
  end  
  
  def forgot_password
    respond_to do |wants|
      wants.html {  }
    end
  end
  
  def reset_password
    @user = User.find_by_email(params[:email]) 
    respond_to do |wants|
    if @user  
      new_password = User.generate_new_password
      @user.password = new_password
      @user.password_confirmation = new_password
      @user.save
      UserMailer.deliver_forgot_password(@user, new_password)
      cookies.delete :auth_token
      reset_session
      flash[:notice] = "Sent new password to #{@user.email}"
       wants.html {  redirect_to root_url }
    else
      flash.now[:error] = 'Email not found'
      wants.html { render :action => "forgot_password" }
    end
    end  
  end
  
  def edit
    @user = User.find(params[:id])
    respond_to do |wants|
      wants.html {  }
    end
  end    
  
  def update
    @user = User.find(params[:id]) 
    respond_to do |wants|
      if @user.update_attributes(params[:user]) 
        wants.html { redirect_to @user }
      else
       wants.html { render :action => "edit" }
      end
    end
  end    
  
  def posts     
     @user = User.find(params[:id],:include => :posts)
     @posts = @user.posts
  end  
  
  def comments
     @user = User.find(params[:id],:include => :comments)
     @comments = @user.comments.group_by { |t| t.commentable }
  end

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = "注册成功!我们已向您的注册邮箱发送了一封激活邮件,请检查您的邮件,多谢!"
    else
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "帐户已激活,你现在就可以登录了!"
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "验证码错误,请使用激活邮件中的激活链接!"
      redirect_back_or_default('/')
    else 
      flash[:error]  = "验证码错误,请使用激活邮件中的激活链接.如果已激活,请直接登录!"
      redirect_back_or_default('/')
    end
  end
end
