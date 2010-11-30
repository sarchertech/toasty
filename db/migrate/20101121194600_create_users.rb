class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :last_name
      t.string :first_name
      t.integer :security_level
      t.references :account
      t.references :salon
      t.string :login

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
