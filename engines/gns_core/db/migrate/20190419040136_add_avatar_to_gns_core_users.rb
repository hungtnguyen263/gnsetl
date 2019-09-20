class AddAvatarToGnsCoreUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :gns_core_users, :avatar, :string
  end
end
