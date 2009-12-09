class Form < ActiveRecord::Base 
  belongs_to :event
  
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :phone_number
end
