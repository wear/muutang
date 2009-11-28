class Page < ActiveRecord::Base   
  
  acts_as_tree :order => "position"   
  
  validates_presence_of :name
  
  named_scope :cates,:conditions => ['parent_id = ?','0']   

  
end
                                                                   