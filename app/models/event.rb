class Event < ActiveRecord::Base   
  validates_presence_of :name
  validates_presence_of :address
  validates_length_of :desc, :minimum => 10      
  validates_presence_of :open_at
  validates_presence_of :close_at
  
  named_scope :opened,:conditions => ['state =?','public']         
  
  def validate    
    if !close_at.nil? && !open_at.nil? && close_at < open_at 
      errors.add(:close_at,'不能小于开始时间') 
    end
  end
  
end
