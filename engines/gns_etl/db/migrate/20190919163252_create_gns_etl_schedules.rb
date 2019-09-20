class CreateGnsEtlSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :gns_etl_schedules do |t|
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.string :comment
      t.integer :status

      t.timestamps
    end
  end
end
