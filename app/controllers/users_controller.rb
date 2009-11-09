class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
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
        render :action => "edit"
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
