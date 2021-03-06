class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += '请激活你的帐户'
    @body[:url]  = "http://www.muutang.com/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += '你的帐户已激活'
    @body[:url]  = "http://www.muutang.com/"
  end  
  
  def forgot_password(user,pwd)
    setup_email(user)
    @subject    += '你的密码已重设'
    @body[:pwd]  = pwd
  end
  
  def new_password(user,pwd)
    setup_email(user)
    @subject    += 'shanghaionrails正式开通线上社区'
    @body[:pwd]  = pwd
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.login} <#{user.email}>"
      @from        = "亩塘 <support@muutang.com>"
      @subject     = "[亩塘] "
      @sent_on     = Time.now
      @body[:user] = user   
      @content_type = "text/html"   
    end
end
