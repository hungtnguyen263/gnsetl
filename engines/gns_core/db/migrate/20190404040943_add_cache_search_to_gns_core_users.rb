class AddCacheSearchToGnsCoreUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :gns_core_users, :cache_search, :string
  end
end
