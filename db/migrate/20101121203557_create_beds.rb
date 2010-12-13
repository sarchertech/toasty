class CreateBeds < ActiveRecord::Migration
  def self.up
    create_table :beds do |t|
      t.references :salon
      t.integer :bed_number
      t.integer :level
      t.string :name
      t.integer :max_time

      t.timestamps
    end

    add_index :beds, :salon_id
  end

  def self.down
    drop_table :beds
  end
end
