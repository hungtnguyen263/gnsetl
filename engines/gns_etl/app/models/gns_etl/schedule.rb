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
      #update_attributes(start_time: Time.now, status: Schedule::STATUS_INPROCESSING)
    end
    
    def run(options)
      log = Logger.new("log/etl_schedule_#{self.id}.log")
      
      update_attributes(start_time: Time.now, status: Schedule::STATUS_INPROCESSING)
      
      # Reading data from Source Database
      count = 0
      SourceDbBase.connection.exec_query("SELECT TOP (#{options[:limit].to_i}) * FROM DN2018").each do |dn|
        count += 1
        
        company_values = "('#{dn["MA_DTNT"]}','#{dn["TEN_DTNT"]}','#{dn["MA_HUYEN"]}','#{dn["MA_TINH"]}')"
        sql_insert_into_companies = "INSERT INTO Companies (CODE, NAME, DISTRICT_ID, CITY_ID) VALUES #{company_values} ON CONFLICT (ID) DO NOTHING;"
        
        company_info_values = "('#{dn["EMAIL"]}','#{dn["TEN_CQTHUE"]}','#{dn["TEN_TINH"]}','#{dn["TEN_HUYEN"]}','#{dn["TEN_LHDN"]}','#{dn["TEN_NGANH"]}')"
        sql_insert_into_company_infos = "INSERT INTO CompanyInfos (email, tax_authority_name, province_name, district_name, type_of_business, industry_name) VALUES #{company_info_values} ON CONFLICT (ID) DO NOTHING;"
        
        begin
          DestinationDbBase.connection.exec_query(sql_insert_into_companies)
          log.info "[Companies] Insert value into table successfully (line: #{count})" # Add log to file log
          self.log("[Companies] Insert value into table successfully (line: #{count}, MA_DTNT: #{dn["MA_DTNT"]})", true) # Add gns_etl_logs table
        rescue => e
          log.error StandardError.new("[Companies] Insert into table values are ignored (line: #{count}) - #{e.message}") # Add log to file log
          self.log("[Companies] Insert into table values are ignored (line: #{count}) - ERROR: #{e.message}", false) # Add gns_etl_logs table
        end
        
        begin  
          DestinationDbBase.connection.exec_query(sql_insert_into_company_infos)
          log.info "[CompanyInfos] Insert value into table successfully (line: #{count})" # Add log to file log
          self.log("[CompanyInfos] Insert value into table successfully (line: #{count})", true) # Add gns_etl_logs table
        rescue => e
          log.error StandardError.new("[CompanyInfos] Insert into table values are ignored (line: #{count}) - #{e.message}") # Add log to file log
          self.log("[CompanyInfos] Insert into table values are ignored (line: #{count}) - ERROR: #{e.message}", false) # Add gns_etl_logs table
        end
      end
      
      # update information
      update_attributes(end_time: Time.now, status: Schedule::STATUS_COMPLETE)
    end
  end
end
