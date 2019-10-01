module GnsEtl
  class TransferValue < ApplicationRecord
    belongs_to :mapping, class_name: 'GnsEtl::Mapping'
  end
end
