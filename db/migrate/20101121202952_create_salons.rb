class CreateSalons < ActiveRecord::Migration
  def self.up
    create_table :salons do |t|
      t.references :account
      t.string :zip_code
      t.string :identifier
      t.string :time_zone
      t.string :address
      t.string :address_2
      t.string :city
      t.string :state
      t.string :staffed_hours
      t.string :static_ip
      t.string :auto_ip
      
      t.timestamps
    end

    add_index :salons, [:account_id, :identifier], :unique => true
  end

  def self.down
    drop_table :salons
  end
end
