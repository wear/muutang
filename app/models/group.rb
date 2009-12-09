class Group < ActiveRecord::Base 
  has_one :wiki
  after_save :create_initial_wiki   
  
  def create_initial_wiki
    if self.wiki.nil?
      Wiki.create(:group => self, :start_page => 'Wiki')
    end
  end
  
end
