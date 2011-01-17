class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :last_name
      t.string :first_name
      t.string :customer_number
      t.integer :level, :default => 0
      t.string :email
      t.string :phone_number
      t.text :address
      t.string :city
      t.string :zip_code
      t.string :state
      t.references :account
      t.references :salon
      t.boolean :under_18, :default => 0
      t.integer :customer_type, :default => 1
      t.date :paid_through
      t.integer :sessions_left

      t.timestamps
    end

    add_index :customers, :account_id
    add_index :customers, :salon_id
  end

  def self.down
    drop_table :customers
  end
end
