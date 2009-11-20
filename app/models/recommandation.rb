class Recommandation < ActiveRecord::Base  
  belongs_to :user
  belongs_to :recommand,:counter_cache => true      
  
  validates_presence_of :user_id
  validates_presence_of :recommand_id                                        
  validates_uniqueness_of :recommand_id, :scope => :user_id
  validates_length_of :desc, :maximum => 120, :allow_nil => true    
  
  cattr_reader :per_page
  @@per_page = 10     
  
end
