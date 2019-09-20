class CreateGnsEtlMappings < ActiveRecord::Migration[5.2]
  def change
    create_table :gns_etl_mappings do |t|
      t.string :source_table
      t.string :source_field
      t.string :source_data_format
      t.string :target_table
      t.string :target_field
      t.string :target_data_format
      t.string :default_value

      t.timestamps
    end
  end
end
