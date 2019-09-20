class CreateGnsEtlTransferValues < ActiveRecord::Migration[5.2]
  def change
    create_table :gns_etl_transfer_values do |t|
      t.integer :schedule_id
      t.integer :mapping_id
      t.integer :reference_id
      t.string :value

      t.timestamps
    end
  end
end
