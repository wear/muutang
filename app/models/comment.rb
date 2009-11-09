class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  
  belongs_to :user
  default_scope :order => 'created_at ASC' 
  validates_presence_of :comment
  validates_presence_of :title
  validates_associated :user 
  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
      
  
  cattr_reader :per_page
  @@per_page = 10
  

end
