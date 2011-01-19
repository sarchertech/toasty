class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :last_name
      t.string :first_name
      t.integer :security_level, :default => 1
      t.references :account
      t.references :salon
      t.string :login
      t.boolean :access_all_locations, :default => 0
      t.string :encrypted_password
      t.string :salt
      t.integer :password_attempts, :default => 0
      t.datetime :wrong_attempt_at
      t.integer :login_suffix, :default => 1

      t.timestamps
    end

    add_index :users, :account_id
    add_index :users, :salon_id
    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table :users
  end
end
