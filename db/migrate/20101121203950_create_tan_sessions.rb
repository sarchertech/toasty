class CreateTanSessions < ActiveRecord::Migration
  def self.up
    create_table :tan_sessions do |t|
      t.references :bed
      t.references :customer
      t.references :salon
      t.integer :minutes

      t.timestamps
    end
    
    add_index :tan_sessions, :customer_id
    add_index :tan_sessions, :salon_id
  end

  def self.down
    drop_table :tan_sessions
  end
end
