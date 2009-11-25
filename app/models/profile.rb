class Profile < ActiveRecord::Base 
  belongs_to :user                          
  
  validates_length_of :name, :within => 3..20, :on => :create, :allow_nil => true
  
  has_attached_file :avatar, :styles => { :medium => "50x50>", :thumb => "16x16>" } 
    
  COMPANY_CATEGORIES = ['foreign_company', 'private_company', 'state_owned_company']
  COMPANY_SIZES      = ['< 10', '10 - 50', '50 - 100', '100 - 500', '> 500']
  TITLES             = ['CTO', 'project_manager', 'architect', 'senior_engineer', 'engineer', 'student']
  INDUSTRIES         = ['web', 'profession_software', 'erp', 'game_development', 'media', 'e_commerce', 'other']
  WORK_EXPERIENCES   = ['< 1 year', '1-3 years', '3-5 years', '5-10 years', '> 10 years']

  
  domain_head_regex = '(?:[A-Z0-9\-]+\.)+'.freeze
  domain_tld_regex  = '(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|jobs|museum)'.freeze
                                                       
  
end
