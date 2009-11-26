class Job < ActiveRecord::Base  
    validates_presence_of :position
    validates_presence_of :contact_name
    validates_length_of :desc, :minimum => 50 
    validates_presence_of :salary
    validates_presence_of :job_address
    validates_presence_of :company
    validates_presence_of :contact_email
    
    named_scope :visible,:conditions => ['visible =?',true]
    named_scope :unvisible,:conditions => ['visible =?',false]    
    
    named_scope :top_five,:conditions => ['visible =?',true],:limit => 5
end
