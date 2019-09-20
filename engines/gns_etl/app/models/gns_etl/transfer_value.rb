module GnsEtl
  class TransferValue < ApplicationRecord
    belongs_to :schedule, class_name: 'GnsEtl::Schedule'
    belongs_to :mapping, class_name: 'GnsEtl::Mapping'
  end
end
