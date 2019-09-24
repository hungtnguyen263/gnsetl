module GnsEtl
  class Schedule < ApplicationRecord
    has_many :logs, class_name: 'GnsEtl::Log'
    
    # const
    STATUS_NEW = 1
    STATUS_INPROCESSING = 2
    STATUS_COMPLETE = 3
    STATUS_CANCELED = 4
    STATUS_FAILED = 5
    
    # add new log
    def log(message=nil, success)
      GnsEtl::Log.add_new(self, message, success)
    end
    
    def start
      update_attributes(start_time: Time.now, status: Schedule::STATUS_INPROCESSING)
    end
    
    def run(options)
      # Do something here
      
      # apply log
      (1..5).each do |c|
        self.log('This a message', true)
      end
      
      # update information
      update_attributes(end_time: Time.now, status: Schedule::STATUS_COMPLETE)
    end
  end
end
