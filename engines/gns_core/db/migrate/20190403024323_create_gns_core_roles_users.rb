class CreateGnsCoreRolesUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :gns_core_roles_users do |t|
      t.references :user, index: true, references: :gns_core_users
      t.references :role, index: true, references: :gns_core_roles

      t.timestamps
    end
  end
end
