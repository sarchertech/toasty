class CreateSalons < ActiveRecord::Migration
  def self.up
    create_table :salons do |t|
      t.references :account
      t.string :name
      t.string :zip_code
      t.string :permalink
      t.string :time_zone
      t.string :address
      t.string :address_2
      t.string :city
      t.string :state
      
      t.timestamps
    end
  end

  def self.down
    drop_table :salons
  end
end
