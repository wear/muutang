class UsersController < ApplicationController  
  
  caches_page :show
  before_filter :login_required,:only => [:change_password,:update_password,:edit,:update]  
  
    
  def show
    @user = User.find(params[:id]) 
    
    respond_to do |wants|
      wants.html { render :layout => 'group' }
    end
  end    
  
  def change_password 
    @section = 'change_password'
    @user =  current_user
    respond_to do |wants|
      wants.html { render :layout => 'setting' }
    end
  end 

  def update_password
    @user = current_user

    respond_to do |format|
      if User.authenticate(@user.email, params[:user][:current_password])
        unless params[:user][:password].blank?
          if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
            flash[:notice] = "密码修改成功!"
            format.html { redirect_to @user }
          else
            flash[:error] = "修改密码出错"
            format.html { render :action => 'change_password' }
          end
        else
            flash[:error] = "新密码不能为空" 
            format.html { render :action => 'change_password' } 
        end
      else
        flash[:error] = '密码错误!'
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
      flash[:notice] = "新密码已发送到#{@user.email}"
       wants.html {  redirect_to root_url }
    else
      flash.now[:error] = '找不到匹配的数据'
      wants.html { render :action => "forgot_password" }
    end
    end  
  end  
  
  def update
    @user = User.find(params[:id]) 
    respond_to do |wants|
      if @user.update_attributes(params[:user]) 
        wants.html { redirect_to @user }
      else
       wants.html { render :action => "edit",:layout => 'setting' }
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
      UserMailer.deliver_signup_notification(@user) 
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
