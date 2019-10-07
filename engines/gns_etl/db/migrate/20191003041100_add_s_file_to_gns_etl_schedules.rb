class AddSFileToGnsEtlSchedules < ActiveRecord::Migration[5.2]
  def change
    add_column :gns_etl_schedules, :s_file, :string
  end
end
