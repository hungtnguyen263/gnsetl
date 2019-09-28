module GnsEtl
  class ScheduleJob < GnsCore::ApplicationJob
    def perform(schedule, options)
      @schedule = schedule
      
      # Run in schedule model
      @schedule.run(options)
    end
  end
end
