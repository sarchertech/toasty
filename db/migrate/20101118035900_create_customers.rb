class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :last_name
      t.string :first_name
      t.string :customer_number
      t.integer :level, :default => 0
      t.string :email
      t.string :phone_number
      t.string :address
      t.string :address_2
      t.date :birth_date
      t.string :city
      t.string :zip_code
      t.string :state
      t.references :account
      t.references :salon

      t.timestamps
    end

    add_index :customers, :account_id
    add_index :customers, :salon_id
  end

  def self.down
    drop_table :customers
  end
end
