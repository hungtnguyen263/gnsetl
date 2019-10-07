module GnsEtl
  class WorkerLoadCSV < GnsCore::ApplicationJob
    def perform(schedule, options)
      @schedule = schedule
      
      # Run in schedule model
      @schedule.import_csv(options)
    end
  end
end
