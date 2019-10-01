class CreateGnsEtlTransferValues < ActiveRecord::Migration[5.2]
  def change
    create_table :gns_etl_transfer_values do |t|
      t.integer :mapping_id
      t.integer :transfer_row_id
      t.integer :reference_id
      t.string :value

      t.timestamps
    end
  end
end
