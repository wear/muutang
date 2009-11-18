class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true,:counter_cache => true
  belongs_to :user                             
  
  default_scope :order => 'created_at ASC' 
  validates_presence_of :comment
  validates_presence_of :title
  validates_associated :user 
  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
      
 # named_scope :grouped,:select => 'comments.commentable_id,comments.commentable_type,comments.user_id,MAX(comments.created_at) as created_at',   
 #    :conditions => ['commentable_type = ?','Post'],:group => 'commentable_id',:include => :user
   
 # named_scope :for_others, lambda { |user| {:joins => "INNER JOIN posts ON posts.id = comments.commentable_id and comments.commentable_type = 'Post'",
 #                                           :conditions => ['posts.user_id <> ?',user] }} 
                                            
 # named_scope :aaa,:joins => "LEFT JOIN 'posts' ON posts.id = comments.commentable_id AND comments.commentable_type = 'Post'"                                                                            
  
  named_scope :group_by_post,:joins => "LEFT JOIN posts ON posts.id = comments.commentable_id AND comments.commentable_type = 'Post'" ,
              :group => 'comments.commentable_id',:conditions => 'posts.user_id <> comments.user_id',:include => :user
  
  cattr_reader :per_page
  @@per_page = 10
  

end
