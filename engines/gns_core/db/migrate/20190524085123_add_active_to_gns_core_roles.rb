class AddActiveToGnsCoreRoles < ActiveRecord::Migration[5.2]
  def change
    add_column :gns_core_roles, :active, :boolean, default: true
  end
end
