module GnsEtl
  class ScheduleJob < GnsCore::ApplicationJob
    def perform(schedule, options)
      @schedule = schedule
      
      @schedule.run(options)
    end
  end
end
