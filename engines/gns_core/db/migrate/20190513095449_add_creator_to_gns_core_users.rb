class AddCreatorToGnsCoreUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :gns_core_users, :creator, index: true, references: :gns_core_users
  end
end
