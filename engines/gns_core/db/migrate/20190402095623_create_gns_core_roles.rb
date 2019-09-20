class CreateGnsCoreRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :gns_core_roles do |t|
      t.string :name

      t.timestamps
    end
  end
end
