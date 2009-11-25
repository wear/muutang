require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken 
  has_many :posts
  has_many :comments
  has_and_belongs_to_many :roles
  has_one :profile
  has_many :skills    
  has_many :recommandations
  has_many :recommands, :through => :recommandations     
  
  validates_presence_of     :login
  validates_length_of       :login,    :within => 2..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_presence_of     :email
  validates_length_of       :email,    :within => 3..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  before_create :make_activation_code,:set_profile
  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email,:password, :password_confirmation,:identity_url 
  
  # Virtual attribute for the unencrypted password
  attr_accessor :current_password
  
  delegate :avatar, :to => :profile
  
  named_scope :prestiged, :conditions => ['profiles.prestige = 1'],:limit => 3,:joins => :profile
  
  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(email, password)
    return nil if email.blank? || password.blank?
    u = find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end 
  
  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end 
  
  def self.generate_new_password(length=6)
    charactars = ("a".."z").to_a + ("A".."Z").to_a + ("1".."9").to_a
    (0..length).inject([]) { |password, i| password << charactars[rand(charactars.size-1)] }.join
  end
  
  def reset_password
    new_password = User.generate_new_password
    self.password = new_password
    self.password_confirmation = new_password
    save(false)
    return new_password
  end

  protected
    
    def make_activation_code
        self.activation_code = self.class.make_token
    end
    
    # before create filter
    def set_profile
      self.profile = Profile.new
    end

end
