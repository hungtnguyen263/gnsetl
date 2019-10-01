class CreateGnsEtlTransferRows < ActiveRecord::Migration[5.2]
  def change
    create_table :gns_etl_transfer_rows do |t|
      t.integer :schedule_id

      t.timestamps
    end
  end
end
