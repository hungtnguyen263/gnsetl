module GnsCore
  class ApplicationJob < ActiveJob::Base
    queue_as :default
  end
end
