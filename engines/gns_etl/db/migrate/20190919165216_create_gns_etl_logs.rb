class CreateGnsEtlLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :gns_etl_logs do |t|
      t.datetime :logtime
      t.integer :stage
      t.string :message
      t.string :trace_data
      t.boolean :success

      t.timestamps
    end
  end
end
