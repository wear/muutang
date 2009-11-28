class Page < ActiveRecord::Base
  acts_as_tree :order => "position"
  
  named_scope :cates,:conditions => ['category = ?','分类']   
  
end
                                                                   