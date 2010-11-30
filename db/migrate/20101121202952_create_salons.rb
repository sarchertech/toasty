class CreateSalons < ActiveRecord::Migration
  def self.up
    create_table :salons do |t|
      t.references :account
      t.string :name
      t.string :zip_code
      t.boolean :rfid_login
      t.string :permalink
      t.string :time_zone

      t.timestamps
    end
  end

  def self.down
    drop_table :salons
  end
end
