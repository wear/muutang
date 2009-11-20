class Recommand < ActiveRecord::Base          
  
  has_many :recommandations
  has_many :users,:through => :recommandations
  
  validates_presence_of :title
  validates_uniqueness_of :title
  validates_presence_of :url  

   cattr_reader :per_page
   @@per_page = 10 
   
   acts_as_commentable  
  
end
