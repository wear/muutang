class Event < ActiveRecord::Base   
  validates_presence_of :name
  validates_presence_of :address
  validates_length_of :desc, :minimum => 10   
  validates_presence_of :start_at
  validates_presence_of :stop_at     
  
  has_one :form
  
  include AASM # Seems to be case sensitive

  aasm_column :state # Should default to state but doesnt appear to work without this!
  aasm_initial_state :pending

  aasm_state :pending  
  aasm_state :public  
  aasm_state :closed
  
  aasm_event :open do
    transitions :from => :pending,:to => :public
  end  
  
  aasm_event :close do
    transitions :from => :public, :to => :closed
  end
  
  named_scope :opened,:conditions => ['state =?','public']         
  
end
