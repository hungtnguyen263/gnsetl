class Ability
  include CanCan::Ability

  def initialize(user)
    
    # Etl / Schedules
    can :update, GnsEtl::Schedule do |schedule|
      schedule.status == 1
    end
    
    can :delete, GnsEtl::Schedule do |schedule|
      false
    end
    
    can :load_csv_ttdn, GnsEtl::Schedule do |schedule|
      true
    end
    
    can :view_logs, GnsEtl::Schedule do |schedule|
      schedule.status != 1
    end
  end
end
