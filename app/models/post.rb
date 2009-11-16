class Post < ActiveRecord::Base
  belongs_to :user,:counter_cache => true 
  belongs_to :category
  validates_length_of :title, :within => 3..80
  validates_length_of :body, :minimum => 10 
  
  named_scope :recent_without_top,:limit => 10,:order => 'updated_at DESC',
              :conditions => ['top = ? and visible = ?',false,true],:include => :user
  named_scope :recent,:order => 'updated_at DESC',
              :conditions => ['visible = ?',true],:include => :user
 
  named_scope :tops,:conditions => ['top = ?',true] 
  
  acts_as_commentable  
  
  cattr_reader :per_page
  @@per_page = 10 
  
  
  def editable?
    created_at.to_date == Date.today
  end
  
  
end
