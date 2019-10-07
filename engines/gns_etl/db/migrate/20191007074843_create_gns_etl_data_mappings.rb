class CreateGnsEtlDataMappings < ActiveRecord::Migration[5.2]
  def change
    create_table :gns_etl_data_mappings do |t|
      t.string :d_table
      t.string :d_field
      t.string :d_data
      t.string :s_data
      
      t.timestamps
    end
  end
end
