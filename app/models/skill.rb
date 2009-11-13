class Skill < ActiveRecord::Base 
  belongs_to :user
  
  validates_presence_of :name
  validates_presence_of :experience_by_year
  
  EXPERIENCES   = ['< 1 year', '1-3 years', '> 3 years']  
    
end
