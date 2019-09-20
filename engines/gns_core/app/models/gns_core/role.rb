module GnsCore
  class Role < ApplicationRecord
    validates :name, presence: true
    
    #has_many :users_roles, class_name: 'GnsCore::UsersRole', dependent: :restrict_with_error
    belongs_to :creator, class_name: 'GnsCore::User'
    has_and_belongs_to_many :users, class_name: 'GnsCore::User'
    has_many :roles_users, class_name: 'GnsCore::RolesUser', dependent: :restrict_with_error
    has_many :roles_permissions, class_name: 'GnsCore::RolesPermission', dependent: :restrict_with_error
    
    # get all active
    def self.get_active
			self.where(active: true)
		end
    
    # Filters
    def self.filter(query, params)
      params = params.to_unsafe_hash
      
      # filter by active
      if params[:active].present?
        query = query.where(active: params[:active])
      end
      
      # single keyword
      if params[:keyword].present?
				keyword = params[:keyword].strip.downcase
				keyword.split(' ').each do |q|
					q = q.strip
					query = query.where('LOWER(gns_core_roles.name) LIKE ?', '%'+q.to_ascii.downcase+'%')
				end
			end

      return query
    end
    
    # search
    def self.search(params)
      query = self.all
      query = self.filter(query, params)

      # order
      if params[:sort_by].present?
        order = params[:sort_by]
        order += " #{params[:sort_direction]}" if params[:sort_direction].present?

        query = query.order(order)
      end

      return query
    end
    
    # get select2 records
    def self.select2(params)
      per_page = 10
      page = 1      
      data = {results: [], pagination: {more: false}}
      
      query = self.get_active
      query = query.order(:name)
      
      # keyword
      if params[:q].present?
        query = query.where('LOWER(gns_core_roles.name) LIKE ?', '%'+params[:q].to_ascii.downcase+'%')
      end
      
      # pagination
      page = params[:page].to_i if params[:page].present?
      query = query.limit(per_page).offset(per_page*(page-1))
      data[:pagination][:more] = true if query.count >= per_page
      
      # render items
      query.each do |user|
        data[:results] << {id: user.id, text: user.name}
      end
      
      return data
    end
    
    # addPermission
    def add_permission(permission)
      roles_permission = self.roles_permissions.where(permission: permission).first
  
      if !roles_permission.present?
        roles_permission = self.roles_permissions.new(permission: permission)
        roles_permission.save
      end
    end
    
    # removePermission
    def remove_permission(permission)
      roles_permission = self.roles_permissions.where(permission: permission).first
      roles_permission.destroy if roles_permission.present?
    end
    
    # hasPermission
    def has_permission?(permission)
      return !self.roles_permissions.where(permission: permission).empty?
    end
    
    # activate
    def activate
			update_attributes(active: true)
		end
    
    # deactivate
    def deactivate
			update_attributes(active: false)
		end
  end
end
