module GnsEtl
  class Log < ApplicationRecord
    belongs_to :schedule, class_name: 'GnsEtl::Schedule', foreign_key: 'schedule_id'
    
    # add log
    def self.add_new(schedule, message=nil, success)
      log = schedule.logs.new
      log.logtime = Time.now
      log.stage = ''
      log.message = message
      log.trace_data = ''
      log.success = success
      
      log.save
    end
  end
end
