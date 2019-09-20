module GnsCore
  class RolesUser < ApplicationRecord
    belongs_to :role, class_name: 'GnsCore::Role'
    has_many :roles_permissions, class_name: 'GnsCore::RolesPermission', dependent: :destroy
  end
end
