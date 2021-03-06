class Post < ActiveRecord::Base
  
  belongs_to :user,:counter_cache => true 
  belongs_to :category
  validates_length_of :title, :within => 3..80
  validates_length_of :body, :minimum => 10 
  
  named_scope :recent_without_top,:limit => 10,:order => 'updated_at DESC',
              :conditions => ['top = ? and visible = ?',false,true],:include => :user

  named_scope :ordered,:conditions => ['visible = ?',true],:order => 'updated_at DESC',:include => :user  
  named_scope :top_five,:conditions => ['top = ?',true],:limit => 5 
  
 # before_save :create_body_pre
  
  acts_as_commentable  
  
  cattr_reader :per_page
  @@per_page = 10          
  
  def editable?
    created_at.to_date == Date.today
  end
  
  
end
