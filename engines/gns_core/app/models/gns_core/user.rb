module GnsCore
  class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable
    
    validates_format_of :email, :presence => true,
												:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
												:message => " is invalid (Eg. 'username@your-domain.com')"
    # validates :password, :length => { :minimum => 6, :maximum => 40 }, :confirmation => true
    
    belongs_to :creator, class_name: "GnsCore::User", optional: true
    has_and_belongs_to_many :roles, class_name: 'GnsCore::Role'
    has_many :roles_users, class_name: 'GnsCore::RolesUser', dependent: :destroy
    #belongs_to :employee, class_name: "GnsEmployee::Employee", optional: true
    #validates :employee_id, uniqueness: true
    
    has_many :notifications_users, class_name: 'GnsNotification::NotificationsUser', dependent: :destroy
    has_many :personal_notes, class_name: 'GnsNote::PersonalNote', dependent: :destroy
    
    mount_uploader :avatar, GnsCore::AvatarUploader
    
    def ability
      @ability ||= Ability.new(self)
    end
    delegate :can?, :cannot?, :to => :ability
    
    def creator_name
      creator.present? ? creator.name : ''
    end
    
    def creator_short_name
      creator.present? ? creator.short_name : ''
    end
    
    def creator_email
      creator.present? ? creator.email : ''
    end
    
    # display name for user
    def name
      name = ''
      #if employee.present?
      #  name = employee.name
      #else
        name = email.rpartition('@').first
      #end
      return name.downcase.titleize
    end
    
    def short_name
      str = []
      str << name.partition(' ').first
      str << name.rpartition(' ').last if !name.partition(' ').last.empty?
      return str.join(" ").downcase.titleize
    end
    
    # update contact cache search
    after_save :update_cache_search
		def update_cache_search
			str = []
			str << name.to_s.downcase.strip #@todo cap nhat moi khi thay doi thong tin employee
			str << email.to_s.downcase.strip

			self.update_column(:cache_search, str.join(" ") + " " + str.join(" ").to_ascii)
		end
    
    # Filters
    def self.filter(query, params)
      params = params.to_unsafe_hash
      
      # filter by active
      #if params[:active].present?
      #  query = query.where(active: params[:active])
      #end
      
      # filter by roles
      if params[:role_ids].present?
        query = query.joins(:roles).where(gns_core_roles_users: {role_id: params[:role_ids]})
      end
      
      # single keyword
      if params[:keyword].present?
				keyword = params[:keyword].strip.downcase
				keyword.split(' ').each do |q|
					q = q.strip
					query = query.where('LOWER(gns_core_users.cache_search) LIKE ?', '%'+q.to_ascii.downcase+'%')
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
      
      query = self.order(:email)
      
      # keyword
      if params[:q].present?
        query = query.where('LOWER(gns_core_users.cache_search) LIKE ?', '%'+params[:q].to_ascii.downcase+'%')
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
    
    # add notification
    def add_notification(phrase, object, remark=nil)
      GnsNotification::Notification.add_new(phrase, object, self, remark)
    end
    
    def notification_unread_count
      self.notifications_users.where(read: false).count
    end
    
    def supreme_administrator?
      # hard code
      return true if self.id == 1
    end
    
    # has system permission
    def has_permission?(permission)
      return true if self.supreme_administrator?
      return !GnsCore::RolesPermission.where(role_id: self.roles.select(:id)).where(permission: permission).empty?
    end
    
    def has_project_permission?(project, permission)
      return false if self.employee.nil?
      
      return self.employee.has_project_permission?(project, permission)
    end
    
  end
end