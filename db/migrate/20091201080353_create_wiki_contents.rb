class CreateWikiContents < ActiveRecord::Migration
  def self.up
    create_table :wiki_contents do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :wiki_contents
  end
end
