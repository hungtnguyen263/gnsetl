module GnsEtl
  class TransferRow < ApplicationRecord
    belongs_to :schedule, class_name: 'GnsEtl::Schedule'
    has_many :transfer_values, class_name: 'GnsEtl::TransferValue', foreign_key: :transfer_row_id
  end
end
