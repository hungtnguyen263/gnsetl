class Ability
  include CanCan::Ability

  def initialize(user)
    # gns_core /users
    can :create, GnsCore::User if user.has_permission?('gns_core.users.create')
    
    can :read, GnsCore::User do |account|
      (user.has_permission?('gns_core.users.read_own') and account.creator == user) or
      (user.has_permission?('gns_core.users.read_other') and account.creator != user)
    end
    
    can :update, GnsCore::User do |account|
      (user.has_permission?('gns_core.users.update_own') and account.creator == user) or
      (user.has_permission?('gns_core.users.update_other') and account.creator != user)
    end
    
    can :lock, GnsCore::User do |account|
      #!account.active? and
      (
        (user.has_permission?('gns_core.users.deactivate_own') and account.creator == user) or
        (user.has_permission?('gns_core.users.deactivate_other') and account.creator != user)
      )
    end
    
    can :unlock, GnsCore::User do |account|
      #account.active? and
      (
        (user.has_permission?('gns_core.users.activate_own') and account.creator == user) or
        (user.has_permission?('gns_core.users.activate_other') and account.creator != user)
      )
    end
    # --------------------------
    
    # gns_core /roles
    can :create, GnsCore::Role if user.has_permission?('gns_core.roles.create')
    
    can :read, GnsCore::Role do |role|
      (user.has_permission?('gns_core.roles.read_own') and role.creator == user) or
      (user.has_permission?('gns_core.roles.read_other') and role.creator != user)
    end
    
    can :set_permissions, GnsCore::Role do |role|
      (user.has_permission?('gns_core.roles.set_permissions_own') and role.creator == user) or
      (user.has_permission?('gns_core.roles.set_permissions_other') and role.creator != user)
    end
    
    can :update, GnsCore::Role do |role|
      (user.has_permission?('gns_core.roles.update_own') and role.creator == user) or
      (user.has_permission?('gns_core.roles.update_other') and role.creator != user)
    end
    
    can :delete, GnsCore::Role do |role|
      (user.has_permission?('gns_core.roles.delete_own') and role.creator == user) or
      (user.has_permission?('gns_core.roles.delete_other') and role.creator != user)
    end
    
    can :activate, GnsCore::Role do |role|
      !role.active? and
      (
        (user.has_permission?('gns_core.roles.activate_own') and role.creator == user) or
        (user.has_permission?('gns_core.roles.activate_other') and role.creator != user)
      )
    end
    
    can :deactivate, GnsCore::Role do |role|
      role.active? and
      (
        (user.has_permission?('gns_core.roles.deactivate_own') and role.creator == user) or
        (user.has_permission?('gns_core.roles.deactivate_other') and role.creator != user)
      )
    end
    # --------------------------
    
    # gns_employee /employees
    can :create, GnsEmployee::Employee if user.has_permission?('gns_employee.employees.create')
    
    can :read, GnsEmployee::Employee do |employee|
      (user.has_permission?('gns_employee.employees.read_own') and employee.creator == user) or
      (user.has_permission?('gns_employee.employees.read_other') and employee.creator != user)
    end
    
    can :update, GnsEmployee::Employee do |employee|
      (user.has_permission?('gns_employee.employees.update_own') and employee.creator == user) or
      (user.has_permission?('gns_employee.employees.update_other') and employee.creator != user)
    end
    
    can :delete, GnsEmployee::Employee do |employee|
      (user.has_permission?('gns_employee.employees.delete_own') and employee.creator == user) or
      (user.has_permission?('gns_employee.employees.delete_other') and employee.creator != user)
    end
    
    can :activate, GnsEmployee::Employee do |employee|
      !employee.active? and
      (
        (user.has_permission?('gns_employee.employees.activate_own') and employee.creator == user) or
        (user.has_permission?('gns_employee.employees.activate_other') and employee.creator != user)
      )
    end
    
    can :deactivate, GnsEmployee::Employee do |employee|
      employee.active? and
      (
        (user.has_permission?('gns_employee.employees.deactivate_own') and employee.creator == user) or
        (user.has_permission?('gns_employee.employees.deactivate_other') and employee.creator != user)
      )
    end
    
    can :create_notification, GnsEmployee::Employee if user.has_permission?('gns_employee.employees.create.notification')
    
    can :update_notification, GnsEmployee::Employee do |employee|
      (user.has_permission?('gns_employee.employees.update_own.notification') and employee.creator == user) or
      (user.has_permission?('gns_employee.employees.update_other.notification') and employee.creator != user)
    end
    
    can :delete_notification, GnsEmployee::Employee do |employee|
      (user.has_permission?('gns_employee.employees.delete_own.notification') and employee.creator == user) or
      (user.has_permission?('gns_employee.employees.delete_other.notification') and employee.creator != user)
    end
    
    can :activate_notification, GnsEmployee::Employee do |employee|
      (user.has_permission?('gns_employee.employees.activate_own.notification') and employee.creator == user) or
      (user.has_permission?('gns_employee.employees.activate_other.notification') and employee.creator != user)
    end
    
    can :deactivate_notification, GnsEmployee::Employee do |employee|
      (user.has_permission?('gns_employee.employees.deactivate_own.notification') and employee.creator == user) or
      (user.has_permission?('gns_employee.employees.deactivate_other.notification') and employee.creator != user)
    end
    # --------------------------
    
    # gns_contact /contacts
    can :create, GnsContact::Contact if user.has_permission?('gns_contact.contacts.create')
    
    can :read, GnsContact::Contact do |contact|
      (user.has_permission?('gns_contact.contacts.read_own') and contact.creator == user) or
      (user.has_permission?('gns_contact.contacts.read_other') and contact.creator != user)
    end
    
    can :update, GnsContact::Contact do |contact|
      (user.has_permission?('gns_contact.contacts.update_own') and contact.creator == user) or
      (user.has_permission?('gns_contact.contacts.update_other') and contact.creator != user)
    end
    
    can :delete, GnsContact::Contact do |contact|
      (user.has_permission?('gns_contact.contacts.delete_own') and contact.creator == user) or
      (user.has_permission?('gns_contact.contacts.delete_other') and contact.creator != user)
    end
    
    can :activate, GnsContact::Contact do |contact|
      !contact.active? and
      (
        (user.has_permission?('gns_contact.contacts.activate_own') and contact.creator == user) or
        (user.has_permission?('gns_contact.contacts.activate_other') and contact.creator != user)
      )
    end
    
    can :deactivate, GnsContact::Contact do |contact|
      contact.active? and
      (
        (user.has_permission?('gns_contact.contacts.deactivate_own') and contact.creator == user) or
        (user.has_permission?('gns_contact.contacts.deactivate_other') and contact.creator != user)
      )
    end
    
    can :create_notification, GnsContact::Contact if user.has_permission?('gns_contact.contacts.create.notification')
    
    can :update_notification, GnsContact::Contact do |contact|
      (user.has_permission?('gns_contact.contacts.update_own.notification') and contact.creator == user) or
      (user.has_permission?('gns_contact.contacts.update_other.notification') and contact.creator != user)
    end
    
    can :delete_notification, GnsContact::Contact do |contact|
      (user.has_permission?('gns_contact.contacts.delete_own.notification') and contact.creator == user) or
      (user.has_permission?('gns_contact.contacts.delete_other.notification') and contact.creator != user)
    end
    
    can :activate_notification, GnsContact::Contact do |contact|
      (user.has_permission?('gns_contact.contacts.activate_own.notification') and contact.creator == user) or
      (user.has_permission?('gns_contact.contacts.activate_other.notification') and contact.creator != user)
    end
    
    can :deactivate_notification, GnsContact::Contact do |contact|
      (user.has_permission?('gns_contact.contacts.deactivate_own.notification') and contact.creator == user) or
      (user.has_permission?('gns_contact.contacts.deactivate_other.notification') and contact.creator != user)
    end
    # --------------------------
    
    # gns_contact /categories
    can :create, GnsContact::Category if user.has_permission?('gns_contact.categories.create')
    
    can :read, GnsContact::Category do |category|
      (user.has_permission?('gns_contact.categories.read_own') and category.creator == user) or
      (user.has_permission?('gns_contact.categories.read_other') and category.creator != user)
    end
    
    can :update, GnsContact::Category do |category|
      (user.has_permission?('gns_contact.categories.update_own') and category.creator == user) or
      (user.has_permission?('gns_contact.categories.update_other') and category.creator != user)
    end
    
    can :delete, GnsContact::Category do |category|
      (user.has_permission?('gns_contact.categories.delete_own') and category.creator == user) or
      (user.has_permission?('gns_contact.categories.delete_other') and category.creator != user)
    end
    
    can :activate, GnsContact::Category do |category|
      !category.active? and
      (
        (user.has_permission?('gns_contact.categories.activate_own') and category.creator == user) or
        (user.has_permission?('gns_contact.categories.activate_other') and category.creator != user)
      )
    end
    
    can :deactivate, GnsContact::Category do |category|
      category.active? and
      (
        (user.has_permission?('gns_contact.categories.deactivate_own') and category.creator == user) or
        (user.has_permission?('gns_contact.categories.deactivate_other') and category.creator != user)
      )
    end
    
    can :create_notification, GnsContact::Category if user.has_permission?('gns_contact.categories.create.notification')
    
    can :update_notification, GnsContact::Category do |category|
      (user.has_permission?('gns_contact.categories.update_own.notification') and category.creator == user) or
      (user.has_permission?('gns_contact.categories.update_other.notification') and category.creator != user)
    end
    
    can :delete_notification, GnsContact::Category do |category|
      (user.has_permission?('gns_contact.categories.delete_own.notification') and category.creator == user) or
      (user.has_permission?('gns_contact.categories.delete_other.notification') and category.creator != user)
    end
    
    can :activate_notification, GnsContact::Category do |category|
      (user.has_permission?('gns_contact.categories.activate_own.notification') and category.creator == user) or
      (user.has_permission?('gns_contact.categories.activate_other.notification') and category.creator != user)
    end
    
    can :deactivate_notification, GnsContact::Category do |category|
      (user.has_permission?('gns_contact.categories.deactivate_own.notification') and category.creator == user) or
      (user.has_permission?('gns_contact.categories.deactivate_other.notification') and category.creator != user)
    end
    # --------------------------
    
    # gns_project /categories
    can :create, GnsProject::Category if user.has_permission?('gns_project.categories.create')
    
    can :read, GnsProject::Category do |category|
      (user.has_permission?('gns_project.categories.read_own') and category.creator == user) or
      (user.has_permission?('gns_project.categories.read_other') and category.creator != user)
    end
    
    can :update, GnsProject::Category do |category|
      (user.has_permission?('gns_project.categories.update_own') and category.creator == user) or
      (user.has_permission?('gns_project.categories.update_other') and category.creator != user)
    end
    
    can :delete, GnsProject::Category do |category|
      (user.has_permission?('gns_project.categories.delete_own') and category.creator == user) or
      (user.has_permission?('gns_project.categories.delete_other') and category.creator != user)
    end
    
    can :activate, GnsProject::Category do |category|
      !category.active? and
      (
        (user.has_permission?('gns_project.categories.activate_own') and category.creator == user) or
        (user.has_permission?('gns_project.categories.activate_other') and category.creator != user)
      )
    end
    
    can :deactivate, GnsProject::Category do |category|
      category.active? and
      (
        (user.has_permission?('gns_project.categories.deactivate_own') and category.creator == user) or
        (user.has_permission?('gns_project.categories.deactivate_other') and category.creator != user)
      )
    end
    
    can :create_notification, GnsProject::Category if user.has_permission?('gns_project.categories.create.notification')
    
    can :update_notification, GnsProject::Category do |category|
      (user.has_permission?('gns_project.categories.update_own.notification') and category.creator == user) or
      (user.has_permission?('gns_project.categories.update_other.notification') and category.creator != user)
    end
    
    can :delete_notification, GnsProject::Category do |category|
      (user.has_permission?('gns_project.categories.delete_own.notification') and category.creator == user) or
      (user.has_permission?('gns_project.categories.delete_other.notification') and category.creator != user)
    end
    
    can :activate_notification, GnsProject::Category do |category|
      (user.has_permission?('gns_project.categories.activate_own.notification') and category.creator == user) or
      (user.has_permission?('gns_project.categories.activate_other.notification') and category.creator != user)
    end
    
    can :deactivate_notification, GnsProject::Category do |category|
      (user.has_permission?('gns_project.categories.deactivate_own.notification') and category.creator == user) or
      (user.has_permission?('gns_project.categories.deactivate_other.notification') and category.creator != user)
    end
    # --------------------------
    
    # gns_project /stages
    can :create, GnsProject::Stage if user.has_permission?('gns_project.stages.create')
    
    can :read, GnsProject::Stage do |stage|
      user.has_permission?('gns_project.stages.read_own') or
      user.has_permission?('gns_project.stages.read_other')
    end
    
    can :update, GnsProject::Stage do |stage|
      user.has_permission?('gns_project.stages.update_own') or
      user.has_permission?('gns_project.stages.update_other')
    end
    
    can :delete, GnsProject::Stage do |stage|
      user.has_permission?('gns_project.stages.delete_own') or
      user.has_permission?('gns_project.stages.delete_other')
    end
    
    can :activate, GnsProject::Stage do |stage|
      user.has_permission?('gns_project.stages.activate_own') or
      user.has_permission?('gns_project.stages.activate_other')
    end
    
    can :deactivate, GnsProject::Stage do |stage|
      user.has_permission?('gns_project.stages.deactivate_own') or
      user.has_permission?('gns_project.stages.deactivate_other')
    end
    
    can :create_notification, GnsProject::Stage if user.has_permission?('gns_project.stages.create.notification')
    
    can :update_notification, GnsProject::Stage do |stage|
      (user.has_permission?('gns_project.stages.update_own.notification') and stage.creator == user) or
      (user.has_permission?('gns_project.stages.update_other.notification') and stage.creator != user)
    end
    
    can :delete_notification, GnsProject::Stage do |stage|
      (user.has_permission?('gns_project.stages.delete_own.notification') and stage.creator == user) or
      (user.has_permission?('gns_project.stages.delete_other.notification') and stage.creator != user)
    end
    
    can :activate_notification, GnsProject::Stage do |stage|
      (user.has_permission?('gns_project.stages.activate_own.notification') and stage.creator == user) or
      (user.has_permission?('gns_project.stages.activate_other.notification') and stage.creator != user)
    end
    
    can :deactivate_notification, GnsProject::Stage do |stage|
      (user.has_permission?('gns_project.stages.deactivate_own.notification') and stage.creator == user) or
      (user.has_permission?('gns_project.stages.deactivate_other.notification') and stage.creator != user)
    end
    # --------------------------
    # gns_project /roles
    can :create, GnsProject::Role if user.has_permission?('gns_project.roles.create')
    
    can :read, GnsProject::Role do |role|
      (user.has_permission?('gns_project.roles.read_own') and role.creator == user) or
      (user.has_permission?('gns_project.roles.read_other') and role.creator != user)
    end
    
    can :set_permissions, GnsProject::Role do |role|
      (user.has_permission?('gns_project.roles.set_permissions_own') and role.creator == user) or
      (user.has_permission?('gns_project.roles.set_permissions_other') and role.creator != user)
    end
    
    can :update, GnsProject::Role do |role|
      (user.has_permission?('gns_project.roles.update_own') and role.creator == user) or
      (user.has_permission?('gns_project.roles.update_other') and role.creator != user)
    end
    
    can :delete, GnsProject::Role do |role|
      (user.has_permission?('gns_project.roles.delete_own') and role.creator == user) or
      (user.has_permission?('gns_project.roles.delete_other') and role.creator != user)
    end
    
    can :activate, GnsProject::Role do |role|
      !role.active? and
      (
        (user.has_permission?('gns_project.roles.activate_own') and role.creator == user) or
        (user.has_permission?('gns_project.roles.activate_other') and role.creator != user)
      )
    end
    
    can :deactivate, GnsProject::Role do |role|
      role.active? and
      (
        (user.has_permission?('gns_project.roles.deactivate_own') and role.creator == user) or
        (user.has_permission?('gns_project.roles.deactivate_other') and role.creator != user)
      )
    end
    
    can :create_notification, GnsProject::Role if user.has_permission?('gns_project.roles.create.notification')
    
    can :update_notification, GnsProject::Role do |role|
      (user.has_permission?('gns_project.roles.update_own.notification') and role.creator == user) or
      (user.has_permission?('gns_project.roles.update_other.notification') and role.creator != user)
    end
    
    can :set_permissions_notification, GnsProject::Role do |role|
      (user.has_permission?('gns_project.roles.set_permissions_own.notification') and role.creator == user) or
      (user.has_permission?('gns_project.roles.set_permissions_other.notification') and role.creator != user)
    end
    
    can :delete_notification, GnsProject::Role do |role|
      (user.has_permission?('gns_project.roles.delete_own.notification') and role.creator == user) or
      (user.has_permission?('gns_project.roles.delete_other.notification') and role.creator != user)
    end
    
    can :activate_notification, GnsProject::Role do |role|
      (user.has_permission?('gns_project.roles.activate_own.notification') and role.creator == user) or
      (user.has_permission?('gns_project.roles.activate_other.notification') and role.creator != user)
    end
    
    can :deactivate_notification, GnsProject::Role do |role|
      (user.has_permission?('gns_project.roles.deactivate_own.notification') and role.creator == user) or
      (user.has_permission?('gns_project.roles.deactivate_other.notification') and role.creator != user)
    end
    # --------------------------
    
    # gns_project / projects
    can :create, GnsProject::Project if user.has_permission?('gns_project.projects.create')
    
    can :read, GnsProject::Project do |project|
      (user.has_permission?('gns_project.projects.read_own') and project.creator == user) or
      (user.has_permission?('gns_project.projects.read_other') and project.creator != user)
    end
    
    can :update, GnsProject::Project do |project|
      (user.has_permission?('gns_project.projects.update_own') and project.creator == user) or
      (user.has_permission?('gns_project.projects.update_other') and project.creator != user)
    end
    
    can :delete, GnsProject::Project do |project|
      project.is_new? and
      (
        (user.has_permission?('gns_project.projects.delete_own') and project.creator == user) or
        (user.has_permission?('gns_project.projects.delete_other') and project.creator != user)
      )
    end
    
    can :activate, GnsProject::Project do |project|
      !project.active? and
      (
        (user.has_permission?('gns_project.projects.activate_own') and project.creator == user) or
        (user.has_permission?('gns_project.projects.activate_other') and project.creator != user)
      )
    end
    
    can :deactivate, GnsProject::Project do |project|
      project.active? and
      (
        (user.has_permission?('gns_project.projects.deactivate_own') and project.creator == user) or
        (user.has_permission?('gns_project.projects.deactivate_other') and project.creator != user)
      )
    end
    
    can :mark_as_new, GnsProject::Project do |project|
      !project.is_new? and
      (
        (user.has_permission?('gns_project.projects.setnew_own') and project.creator == user) or
        (user.has_permission?('gns_project.projects.setnew_other') and project.creator != user)
      )
    end
    
    can :send_request, GnsProject::Project do |project|
      (
        project.is_new? and
        (
          project.tasks.count > 0 and project.tasks.assigned_all?
        )
      ) and
      (
        (user.has_permission?('gns_project.projects.setpending_own') and project.creator == user) or
        (user.has_permission?('gns_project.projects.setpending_other') and project.creator != user)
      )
    end
    
    can :start_project, GnsProject::Project do |project|
      (project.is_pending? and project.tasks.count > 0) and
      (
        (user.has_permission?('gns_project.projects.setinprogress_own') and project.creator == user) or
        (user.has_permission?('gns_project.projects.setinprogress_other') and project.creator != user)
      )
    end
    
    can :finish, GnsProject::Project do |project|
      (project.is_in_progress? and (project.get_tasks_not_closed.count == 0 and project.progress_percent == 100)) and
      (
        (user.has_permission?('gns_project.projects.setfinished_own') and project.creator == user) or
        (user.has_permission?('gns_project.projects.setfinished_other') and project.creator != user)
      )
    end
    
    can :manpower_authorize, GnsProject::Project do |project|
      user.has_permission?('gns_project.projects.authorize_own') or
      user.has_permission?('gns_project.projects.authorize_other')
    end
    
    can :download_attachments, GnsProject::Project do |project|
      project.count_attachments > 0
    end
    
    # project notifications
    can :create_notification, GnsProject::Project if user.has_permission?('gns_project.projects.create.notification')
    
    can :update_notification, GnsProject::Project do |project|
      (user.has_permission?('gns_project.projects.update_own.notification') and project.creator == user) or
      (user.has_permission?('gns_project.projects.update_other.notification') and project.creator != user)
    end
    
    can :delete_notification, GnsProject::Project do |project|
      (user.has_permission?('gns_project.projects.delete_own.notification') and project.creator == user) or
      (user.has_permission?('gns_project.projects.delete_other.notification') and project.creator != user)
    end
    
    can :activate_notification, GnsProject::Project do |employee|
      (user.has_permission?('gns_project.projects.activate_own.notification') and project.creator == user) or
      (user.has_permission?('gns_project.projects.activate_other.notification') and project.creator != user)
    end
    
    can :deactivate_notification, GnsProject::Project do |project|
      (user.has_permission?('gns_project.projects.deactivate_own.notification') and project.creator == user) or
      (user.has_permission?('gns_project.projects.deactivate_other.notification') and project.creator != user)
    end
    
    can :mark_as_new_notification, GnsProject::Project do |employee|
      (user.has_permission?('gns_project.projects.setnew_own.notification') and project.creator == user) or
      (user.has_permission?('gns_project.projects.setnew_other.notification') and project.creator != user)
    end
    
    can :send_request_notification, GnsProject::Project do |project|
      (user.has_permission?('gns_project.projects.setpending_own.notification') and project.creator == user) or
      (user.has_permission?('gns_project.projects.setpending_other.notification') and project.creator != user)
    end
    
    can :start_project_notification, GnsProject::Project do |project|
      (user.has_permission?('gns_project.projects.setinprogress_own.notification') and project.creator == user) or
      (user.has_permission?('gns_project.projects.setinprogress_other.notification') and project.creator != user)
    end
    
    can :finish_notification, GnsProject::Project do |employee|
      (user.has_permission?('gns_project.projects.setfinished_own.notification') and project.creator == user) or
      (user.has_permission?('gns_project.projects.setfinished_other.notification') and project.creator != user)
    end
    
    can :download_attachments_notification, GnsProject::Project do |project|
      (user.has_permission?('gns_project.projects.download_attachments_own.notification') and project.creator == user) or
      (user.has_permission?('gns_project.projects.download_attachments_other.notification') and project.creator != user)
    end
    # --------------------------
    
    # gns_project / tasks
    can :create_task, GnsProject::Project do |project|
      (!project.is_finished?) and
      user.has_project_permission?(project, 'gns_project.tasks.create')
    end
    
    can :read, GnsProject::Task do |task|
      (user.has_project_permission?(task.project, 'gns_project.tasks.read_own') and task.employee == user.employee) or
      (user.has_project_permission?(task.project, 'gns_project.tasks.read_other') and task.employee != user.employee)
    end
    
    can :update, GnsProject::Task do |task|
      (!task.project.is_finished?) and
      (
        (
          user.has_project_permission?(task.project, 'gns_project.tasks.update_own') and
          (
            task.employee == user.employee or task.creator == user
          )
        ) or
        (
          user.has_project_permission?(task.project, 'gns_project.tasks.update_other') and
          (
            task.employee != user.employee or task.creator != user
          )
        )
      )
    end
    
    can :delete, GnsProject::Task do |task|
      (task.attachments.count == 0 and !task.project.is_finished?) and
      (
        (user.has_project_permission?(task.project, 'gns_project.tasks.delete_own') and task.employee == user.employee) or
        (user.has_project_permission?(task.project, 'gns_project.tasks.delete_other') and task.employee != user.employee)
      )
    end
    
    can :finish, GnsProject::Task do |task|
      (!task.finished? and task.progress == 100) and
      (
        (user.has_project_permission?(task.project, 'gns_project.tasks.finish_own') and task.employee == user.employee) or
        (user.has_project_permission?(task.project, 'gns_project.tasks.finish_other') and task.employee != user.employee)
      )
    end
    
    can :unfinish, GnsProject::Task do |task|
      (task.finished? and task.is_open?) and
      (
        (user.has_project_permission?(task.project, 'gns_project.tasks.unfinish_own') and task.employee == user.employee) or
        (user.has_project_permission?(task.project, 'gns_project.tasks.unfinish_other') and task.employee != user.employee)
      )
    end
    
    can :close, GnsProject::Task do |task|
      (task.finished? and task.is_open?) and
      (
        (user.has_project_permission?(task.project, 'gns_project.tasks.close_own') and task.employee == user.employee) or
        (user.has_project_permission?(task.project, 'gns_project.tasks.close_other') and task.employee != user.employee)
      )
    end
    
    can :reopen, GnsProject::Task do |task|
      (task.finished? and task.is_closed?) and
      (
        (user.has_project_permission?(task.project, 'gns_project.tasks.reopen_own') and task.employee == user.employee) or
        (user.has_project_permission?(task.project, 'gns_project.tasks.reopen_other') and task.employee != user.employee)
      )
    end
    
    can :update_progress, GnsProject::Task do |task|
      (task.project.is_in_progress? and !task.finished?) and
      (
        (user.has_project_permission?(task.project, 'gns_project.tasks.update_progress_own') and task.employee == user.employee) or
        (user.has_project_permission?(task.project, 'gns_project.tasks.update_progress_other') and task.employee != user.employee)
      )
    end
    
    can :attachments, GnsProject::Task do |task|
      #task.employee == user.employee
      true
    end
    
    can :download_attachments, GnsProject::Task do |task|
      task.count_attachments > 0
    end
    
    # task notifications
    can :create_task_notification, GnsProject::Project do |project|
      user.has_project_permission?(project, 'gns_project.tasks.create.notification')
    end
    
    can :update_notification, GnsProject::Task do |task|
      (
        user.has_project_permission?(task.project, 'gns_project.tasks.update_own') and
        (
          task.employee == user.employee or task.creator == user
        )
      ) or
      (
        user.has_project_permission?(task.project, 'gns_project.tasks.update_other') and
        (
          task.employee != user.employee or task.creator != user
        )
      )
    end
    
    can :delete_notification, GnsProject::Task do |task|
      (user.has_project_permission?(task.project, 'gns_project.tasks.delete_own') and task.employee == user.employee) or
      (user.has_project_permission?(task.project, 'gns_project.tasks.delete_other') and task.employee != user.employee)
    end
    
    can :finish_notification, GnsProject::Task do |task|
      (user.has_project_permission?(task.project, 'gns_project.tasks.finish_own') and task.employee == user.employee) or
      (user.has_project_permission?(task.project, 'gns_project.tasks.finish_other') and task.employee != user.employee)
    end
    
    can :unfinish_notification, GnsProject::Task do |task|
      (user.has_project_permission?(task.project, 'gns_project.tasks.unfinish_own') and task.employee == user.employee) or
      (user.has_project_permission?(task.project, 'gns_project.tasks.unfinish_other') and task.employee != user.employee)
    end
    
    can :close_notification, GnsProject::Task do |task|
      (user.has_project_permission?(task.project, 'gns_project.tasks.close_own') and task.employee == user.employee) or
      (user.has_project_permission?(task.project, 'gns_project.tasks.close_other') and task.employee != user.employee)
    end
    
    can :reopen_notification, GnsProject::Task do |task|
      (user.has_project_permission?(task.project, 'gns_project.tasks.reopen_own') and task.employee == user.employee) or
      (user.has_project_permission?(task.project, 'gns_project.tasks.reopen_other') and task.employee != user.employee)
    end
    
    can :update_progress_notification, GnsProject::Task do |task|
      (user.has_project_permission?(task.project, 'gns_project.tasks.update_progress_own') and task.employee == user.employee) or
      (user.has_project_permission?(task.project, 'gns_project.tasks.update_progress_other') and task.employee != user.employee)
    end
    
    # --------------------------
    
    # gns_project / attachments
    can :download, GnsProject::Attachment do |att|
      true
    end
    # --------------------------
    
    # gns_project / comments
    can :add_new_commnet, GnsProject::Project do |project|
      true
    end
    
    can :reply, GnsProject::Comment do |comment|
      true
    end
    
    can :update, GnsProject::Comment do |comment|
      true
    end
    
    can :delete, GnsProject::Comment do |comment|
      true
    end
    
    can :download, GnsProject::Comment do |comment|
      false
    end
    # --------------------------
    
    # gns_project /templates
    can :create, GnsProject::Template if user.has_permission?('gns_project.templates.create')
    
    can :read, GnsProject::Template do |template|
      (user.has_permission?('gns_project.templates.read_own') and template.creator == user) or
      (user.has_permission?('gns_project.templates.read_other') and template.creator != user)
    end
    
    can :update, GnsProject::Template do |template|
      (user.has_permission?('gns_project.templates.update_own') and template.creator == user) or
      (user.has_permission?('gns_project.templates.update_other') and template.creator != user)
    end
    
    can :delete, GnsProject::Template do |template|
      (user.has_permission?('gns_project.templates.delete_own') and template.creator == user) or
      (user.has_permission?('gns_project.templates.delete_other') and template.creator != user)
    end
    
    #can :activate, GnsProject::Template do |template|
    #  !template.active? and
    #  (
    #    (user.has_permission?('gns_project.templates.activate_own') and template.creator == user) or
    #    (user.has_permission?('gns_project.templates.activate_other') and template.creator != user)
    #  )
    #end
    #
    #can :deactivate, GnsProject::Template do |template|
    #  template.active? and
    #  (
    #    (user.has_permission?('gns_project.template.deactivate_own') and template.creator == user) or
    #    (user.has_permission?('gns_project.template.deactivate_other') and template.creator != user)
    #  )
    #end
    
    # template notifications
    can :create_notification, GnsProject::Template if user.has_permission?('gns_project.templates.create.notification')
    
    can :update_notification, GnsProject::Template do |template|
      (user.has_permission?('gns_project.templates.update_own.notification') and template.creator == user) or
      (user.has_permission?('gns_project.templates.update_other.notification') and template.creator != user)
    end
    
    can :delete_notification, GnsProject::Template do |template|
      (user.has_permission?('gns_project.templates.delete_own.notification') and template.creator == user) or
      (user.has_permission?('gns_project.templates.delete_other.notification') and template.creator != user)
    end
    # --------------------------
    
    # gns_note /personal notes
    can :update, GnsNote::PersonalNote do |personal_note|
      personal_note.user == user
    end
    
    can :delete, GnsNote::PersonalNote do |personal_note|
      personal_note.user == user
    end
    
    can :mark_as_done, GnsNote::PersonalNote do |personal_note|
      !personal_note.is_done? and personal_note.user == user
    end
    
    can :mark_as_not_done_yet, GnsNote::PersonalNote do |personal_note|
      personal_note.is_done? and personal_note.user == user
    end
    # --------------------------
  end
end
