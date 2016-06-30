class CreateBaseStructure < ActiveRecord::Migration[5.0]

  def self.up
    create_table :books do |t|
      t.string :asin, :title, :author
      t.integer :highlight_count
      t.timestamps
    end
    create_table :highlights do |t|
      t.text :highlight
      t.string :amazon_id
      t.integer :book_id
      t.timestamps
    end
  end

  def self.down
    drop_table :books
    drop_table :highlights
  end

end
