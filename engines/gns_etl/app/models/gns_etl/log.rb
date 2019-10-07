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
    
    # filters
    def self.filter(query, params)
      params = params.to_unsafe_hash
      
      # single keyword
      if params[:keyword].present?
				keyword = params[:keyword].strip.downcase
				keyword.split(' ').each do |q|
					q = q.strip
					query = query.where('LOWER(gns_etl_logs.message) LIKE ?', '%'+q.to_ascii.strip.downcase+'%')
				end
			end

      return query
    end
    
    # searchs
    def self.search(params)
      query = self.all
      query = self.filter(query, params)

      # order
      if params[:sort_by].present?
        order = params[:sort_by]
        order += " #{params[:sort_direction]}" if params[:sort_direction].present?

        query = query.order(order)
      end

      return query
    end
  end
end
