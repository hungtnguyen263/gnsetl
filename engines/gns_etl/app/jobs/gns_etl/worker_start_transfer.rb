module GnsEtl
  class WorkerStartTransfer < GnsCore::ApplicationJob
    def perform(schedule, options)
      @schedule = schedule
      
      # Run in schedule model
      @schedule.transfer(options)
    end
  end
end
