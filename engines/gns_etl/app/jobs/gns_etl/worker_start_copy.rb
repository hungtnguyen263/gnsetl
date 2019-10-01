module GnsEtl
  class WorkerStartCopy < GnsCore::ApplicationJob
    def perform(schedule, options)
      @schedule = schedule
      
      # Run in schedule model
      @schedule.copy(options)
    end
  end
end
