class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :account_number
      t.string :name
      t.string :sub_domain

      t.timestamps
    end

    add_index :accounts, :sub_domain, :unique => true
  end

  def self.down
    drop_table :accounts
  end
end
