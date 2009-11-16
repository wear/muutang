class Category < ActiveRecord::Base
  has_many :posts
  validates_presence_of :name  
  
  acts_as_list
  
  named_scope :ordered,:order => 'position ASC'
end
