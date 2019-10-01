class CreateGnsEtlMappings < ActiveRecord::Migration[5.2]
  def change
    create_table :gns_etl_mappings do |t|
      t.string :source_table
      t.string :source_field
      t.string :source_data_format
      t.string :destination_table
      t.string :destination_field
      t.string :destination_data_format
      t.string :default_value

      t.timestamps
    end
  end
end
