class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.boolean :customer_location_access
      t.boolean :user_location_access
      t.integer :account_number
      t.string :name
      t.string :sub_domain

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
