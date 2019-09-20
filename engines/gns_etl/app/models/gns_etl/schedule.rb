module GnsEtl
  class Schedule < ApplicationRecord
    # const
    STATUS_NEW = 1
    STATUS_INPROCESSING = 2
    STATUS_COMPLETE = 3
    STATUS_CANCELED = 4
    STATUS_FAILED = 5
    
    def start
      update_attributes(start_time: Time.now, status: Schedule::STATUS_INPROCESSING)
    end
    
    def run(options)
      # Do something here
      
      update_attributes(end_time: Time.now, status: Schedule::STATUS_COMPLETE)
    end
  end
end
