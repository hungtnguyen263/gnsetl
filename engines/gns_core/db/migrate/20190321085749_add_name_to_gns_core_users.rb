class AddNameToGnsCoreUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :gns_core_users, :first_name, :string
    add_column :gns_core_users, :last_name, :string
  end
end
