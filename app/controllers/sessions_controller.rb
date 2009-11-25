# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem   
      
  # render new.rhtml      
  
  def new
  end

  def create
    logout_keeping_session!
    if using_open_id?
      open_id_authentication(params[:openid_url])
    else                
      user = User.authenticate(params[:email], params[:password])
      if user
        # Protects against session fixation attacks, causes request forgery
        # protection if user resubmits an earlier form using back
        # button. Uncomment if you understand the tradeoffs.
        # reset_session
        self.current_user = user
        new_cookie_flag = (params[:remember_me] == "1")
        handle_remember_cookie! new_cookie_flag
        redirect_back_or_default('/')
        flash[:notice] = "你已成功登录!"
      else
        note_failed_signin
        @email       = params[:email]
        @remember_me = params[:remember_me]
        render :action => 'new'
      end
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end   
  #
  # If we want to get the GMail address for a user using Google Federated Login,
  # we need to work with AX attributes, not SReg attributes which is used by
  # default.
  #
  # To solve this Ax/SReg attribute problem we patch the OpenIdAuthentication
  # module to use AX attributes when talking to the Google OpenID server
  #
  # This patch is based on the source from github[1], January 4, 2009
  #
  # 1. http://github.com/rails/open_id_authentication/commits/master
  #
  module ::OpenIdAuthentication
    require 'openid/extensions/ax'

    private
    def add_simple_registration_fields(open_id_request, fields)
      if is_google_federated_login?(open_id_request)
        ax_request = OpenID::AX::FetchRequest.new
        # Only the email attribute is currently supported by google federated login
        email_attr = OpenID::AX::AttrInfo.new('http://schema.openid.net/contact/email', 'email', true)
        ax_request.add(email_attr)
        open_id_request.add_extension(ax_request)
      else
        sreg_request = OpenID::SReg::Request.new
        sreg_request.request_fields(Array(fields[:required]).map(&:to_s), true) if fields[:required]
        sreg_request.request_fields(Array(fields[:optional]).map(&:to_s), false) if fields[:optional]
        sreg_request.policy_url = fields[:policy_url] if fields[:policy_url]
        open_id_request.add_extension(sreg_request)
      end
    end

    def complete_open_id_authentication
      params_with_path = params.reject { |key, value| request.path_parameters[key] }
      params_with_path.delete(:format)
      open_id_response = timeout_protection_from_identity_server { open_id_consumer.complete(params_with_path, requested_url) }
      identity_url     = normalize_identifier(open_id_response.display_identifier) if open_id_response.display_identifier

      case open_id_response.status
      when OpenID::Consumer::SUCCESS
        if is_google_federated_login?(open_id_response)
          yield Result[:successful], params['openid.identity'], OpenID::AX::FetchResponse.from_success_response(open_id_response)
        else
          yield Result[:successful], identity_url, OpenID::SReg::Response.from_success_response(open_id_response)
        end
      when OpenID::Consumer::CANCEL
        yield Result[:canceled], identity_url, nil
      when OpenID::Consumer::FAILURE
        yield Result[:failed], identity_url, nil
      when OpenID::Consumer::SETUP_NEEDED
        yield Result[:setup_needed], open_id_response.setup_url, nil
      end
    end

    def is_google_federated_login?(request_response)
      return request_response.endpoint.server_url == "https://www.google.com/accounts/o8/ud"
    end
  end
 
  protected
    # Track failed login attempts
    def note_failed_signin
      flash[:error] = "用户名或密码错误!"
      logger.warn "Failed login for '#{params[:email]}' from #{request.remote_ip} at #{Time.now.utc}"
    end    

    def open_id_authentication(openid_url)
      authenticate_with_open_id(openid_url, {:required => [ 'email' ] }) do |result, identity_url, registration|
        case result.status
        when :missing
          failed_login "Sorry, the OpenID server couldn't be found"
        when :invalid
          failed_login "Sorry, but this does not appear to be a valid OpenID"
        when :canceled
          failed_login "OpenID verification was canceled"
        when :failed
          failed_login "Sorry, the OpenID verification failed"
        when :successful
          if registration.class.to_s == "OpenID::AX::FetchResponse"
            email = registration['http://schema.openid.net/contact/email']
          else
            email = registration['email']
          end
          @user = User.find_or_initialize_by_email(email)
          if @user.new_record?  
            @user.identity_url = identity_url
            @user.login = email.to_s  
            @user.email = email.to_s
            @user.save(false)
          end
          self.current_user = @user
          successful_login 
        else
          failed_login result.message
        end
      end   
    end



    private
      def successful_login
        session[:user_id] = @current_user.id
        redirect_to(root_url)
      end

      def failed_login(message)
        flash[:error] = message
        redirect_to(new_session_url)
      end

end
