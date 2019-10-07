module GnsEtl
  class Schedule < ApplicationRecord
    has_many :logs, class_name: 'GnsEtl::Log'
    has_many :transfer_rows, class_name: 'GnsEtl::TransferRow', foreign_key: :schedule_id
    
    validates :name, :s_file, presence: true
    
    # const
    STATUS_NEW = 1
    STATUS_COPYING = 2
    STATUS_COPIED = 3
    STATUS_TRANSFERRING = 4
    STATUS_TRANSFERRED = 5
    STATUS_CANCELED = 6
    STATUS_FAILED = 7
    STATUS_INPROCESSING = 8
    STATUS_COMPLETE = 9
    
    # add new log
    def log(message=nil, success)
      GnsEtl::Log.add_new(self, message, success)
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
    
    # get source files
    def self.source_file_options
      folder_path = File.join(Rails.root, "../source_datas")
      files = Dir.children(folder_path)
      
      options = []
      options = files.map {|f| {text: f, value: folder_path + '/' + f}}
      
      return options
    end
    
    # Lay Id cua Khu vuc trong TargetDatabase
    def get_area(row)
      area = {}
      begin
        begin
          native_city = row[:native_city].to_s.split(/Tỉnh|Thành phố|Thành Phố/).map(&:strip).reject(&:empty?)[0]
          
          province_name = native_city
          dmap_province = GnsEtl::DataMapping.where(d_table: 'Provinces', d_field: 'Name', s_data: native_city).first
          province_name = dmap_province.d_data if !dmap_province.nil?
          logger.info '========Province========'
          logger.info province_name
          
          province = DestinationDbBase.connection.exec_query("SELECT * FROM \"Provinces\" WHERE \"Name\" LIKE '%#{province_name}%'").first
          provinceID = province["Id"]
          provinceCode = province["ProvinceCode"]
          
          # add provinceID to hash
          area[:provinceID] = provinceID
        rescue => error
          # Log failed
          self.log(
            "[#{row[:native_city].to_s} (CompanyCode: #{row[:ent_internal_code]} - CompanyName: #{row[:vietnamese_name]})] - Cannot find province/city matching database of system => #{error.message}",
            false
          )
        end
        
        begin
          native_district = row[:native_district].split(/Huyện|Quận|Thị xã|Thị Xã|Thành phố|Thành Phố|Tp|TP/).map(&:strip).reject(&:empty?)[0]
          
          district_name = native_district
          dmap_district = GnsEtl::DataMapping.where(d_table: 'Districts', d_field: 'Name', s_data: native_district).first
          district_name = dmap_district.d_data if !dmap_district.nil?
          logger.info '========District========'
          logger.info district_name
          
          district = DestinationDbBase.connection.exec_query("SELECT * FROM \"Districts\" WHERE \"Name\" LIKE '%#{district_name}%' AND \"ProvinceCode\" = '#{provinceCode}'").first
          districtID = district["Id"]
          
          # add districtID to hash
          area[:districtID] = districtID
        rescue => error
          # Log failed
          self.log(
            "[#{row[:native_district].to_s} (CompanyCode: #{row[:ent_internal_code]} - CompanyName: #{row[:vietnamese_name]})] - Cannot find district matching database of system => #{error.message}",
            false
          )
        end
      rescue => error
        # Log failed
        self.log(
          "[CompanyCode: #{row[:ent_internal_code]} - CompanyName: #{row[:vietnamese_name]}] - #{error.message}",
          false
        )
      end
      
      return area
    end
    
    # import CSV file
    def import_csv(options={})
      file = self.s_file
      options = {headers: true, :row_sep => "\r\n", :col_sep => "','", header_converters: :symbol, converters: %i[date], :quote_char => "\x00"}
      
      update_attributes(start_time: Time.now, status: Schedule::STATUS_INPROCESSING)
      begin
        # Run the loop through each line of the file
        CSV.foreach(file, "rb:bom|utf-8", options) do |row|
          begin
            # get id province on DestinationDB
            area = self.get_area(row)
            
            # Query insert into Companies table
            query_insert_into_companies = "INSERT INTO \"Companies\" (\"Id\", \"CompanyCode\", \"Name\", \"TaxNumber\", \"PhoneNumber\""
            query_insert_into_companies += ", \"Email\", \"WebSite\", \"Fax\", \"Address\", \"DistrictId\", \"ProvinceId\")"
            query_insert_into_companies += " VALUES ("
            query_insert_into_companies += "'#{SecureRandom.uuid}', '#{row[:ent_internal_code]}'"
            query_insert_into_companies += ", '#{row[:vietnamese_name]}', '#{row[:ent_tax_code]}'"
            query_insert_into_companies += ", '#{row[:ho_phone]}', '#{row[:ho_email]}'"
            query_insert_into_companies += ", '#{row[:ho_url]}', '#{row[:ho_fax]}'"
            query_insert_into_companies += ", '#{row[:native_address]}', '#{area[:districtID]}', '#{area[:provinceID]}'"
            query_insert_into_companies += ")"
            #query_insert_into_companies += " ON CONFLICT (\"CompanyCode\") DO NOTHING" # G::InvalidColumnReference: ERROR:  there is no unique or exclusion constraint matching the ON CONFLICT specification
            
            
            #DestinationDbBase.connection.exec_query(query_insert_into_companies)
            
            exist = DestinationDbBase.connection.exec_query("SELECT COUNT(*) FROM \"Companies\" WHERE \"CompanyCode\" = '#{row[:ent_internal_code]}';").first["count"]
            if exist == 0
              begin
                DestinationDbBase.connection.exec_query(query_insert_into_companies)
                # Log success
                self.log(
                  "#{query_insert_into_companies}: record imported!",
                  true
                )
              rescue => error
                # Log failed => Lỗi trong quá trình ghi (insert) dữ liệu
                self.log(
                  "[Cann't import data from csv file] - #{query_insert_into_companies} => #{error.message}",
                  false
                )
              end
            else
              # Log failed => Cảnh báo trùng data
              self.log(
                "[CompanyCode: #{row[:ent_internal_code]} - CompanyName: #{row[:vietnamese_name]}] - This record already exists",
                false
              )
            end
          rescue => error
            # Log failed => Lỗi trong quá trình đọc và insert dữ liệu
            self.log(
              "[CompanyCode: #{row[:ent_internal_code]} - CompanyName: #{row[:vietnamese_name]}] ERROR - #{error.message}",
              false
            )
          end
        end # het 1 vong lap cua moi row trong csv
      rescue => error
        # Log failed => Ghi lỗi trên từng row của file csv
        self.log(
          "[CSV FILE ERROR] - #{error.message}",
          false
        )
      end
      
      # update information
      update_attributes(end_time: Time.now, status: Schedule::STATUS_COMPLETE)
    end
    
    # Read and copy data from source database to temporary tables
    def copy(options)
      # set status is copying
      update_attributes(start_time: Time.now, status: Schedule::STATUS_COPYING)
      
      # get all s_tables
      s_tables = GnsEtl::Mapping.all.map(&:source_table).uniq
      
      s_tables.each do |s_table|
        # get all mapping of s_table
        mappings = GnsEtl::Mapping.where(source_table: s_table)
      
        # select all records from s_table
        begin
          data = SourceDbBase.connection.exec_query("SELECT TOP (10) * FROM #{s_table}")
        rescue
          # Log failed
          self.log(
            "Cann't get record from #{s_table} - ERROR: #{e.message}",
            false
          )
          
          break
        end
      
        data.each do |record|     # try catch logger
          # new row
          tfRow = GnsEtl::TransferRow.new
          tfRow.schedule_id = self.id
          tfRow.save
          
          # get column value one by one
          mappings.each do |mapping|
            # new transfer value
            tfValue = GnsEtl::TransferValue.new
            tfValue.transfer_row_id = tfRow.id
            tfValue.mapping_id = mapping.id
            tfValue.value = record["#{mapping.source_field}"]
            
            begin
              tfValue.save!
              
              # Log success
              self.log(
                "[#{s_table}, #{mapping.source_field}] value copied!",
                true
              )
            rescue => e
              # Log falied
              self.log(
                "[#{s_table}, #{mapping.source_field}] copy failed:  - ERROR: #{e.message}",
                false
              )
              
              break
            end
          end
        end
      end
      
      # set status is copied
      update_attributes(status: Schedule::STATUS_COPIED)
    end
    
    # Transfer data from the temporary table to the target database
    def transfer(options)
      update_attributes(status: Schedule::STATUS_TRANSFERRING)

      # foreach all rows
      self.transfer_rows.each do |transfer_row|
        # tables
        tables = {}
    
        # find columns and values each row of one or more tables
        transfer_row.transfer_values.each do |transfer_value|
          # add table if not exist
          if !tables[transfer_value.mapping.destination_table].present?
            tables[transfer_value.mapping.destination_table] = {columns: [], values: []}
          end
          # add columns name, values to table
          tables[transfer_value.mapping.destination_table][:columns] << transfer_value.mapping.destination_field
          tables[transfer_value.mapping.destination_table][:values] << transfer_value.value
        end
    
        # insert to d_tables
        tables.each do |table|
          columns = table[1][:columns]
          values = table[1][:values]
          
          #logger.info table
          #logger.info table[0]
          #logger.info table[1][:columns]
          #logger.info table[1][:values]
    
          # inser 1 row to 1 d_table
          begin
            DestinationDbBase.connection.execute("INSERT INTO \"#{table[0]}\" (\"Id\", #{columns.map(&:inspect).join(', ')}) VALUES ('#{SecureRandom.uuid}', '#{values.join("', '")}')")   # ON CONFLICT (code) DO NOTHING;
            # Log success
            self.log(
              "Insert into #{table[0]} (#{columns.join(',')}) values (#{values.map(&:inspect).join(',')}): record transferred!",
              true
            )
          rescue => e
            # Log falied
            self.log(
              "[Insert into #{table[0]} (#{columns.join(',')}) values (#{values.map(&:inspect).join(',')})]: transfer failed:  - ERROR: #{e.message}",
              false
            )
            
            break
          end
        end
      end
      
      # Log success
      self.log(
        "[#{self.name}] Datas has been transferred",
        true
      )
      
      update_attributes(end_time: Time.now, status: Schedule::STATUS_TRANSFERRED)
    end
  end
end
