module GnsEtl
  class Mapping < ApplicationRecord
    
    # filters
    def self.filter(query, params)
      params = params.to_unsafe_hash
      
      # filter by source table
      if params[:source_table].present?
        query = query.where(source_table: params[:source_table])
      end
      
      # filter by destination table
      if params[:destination_table].present?
        query = query.where(destination_table: params[:destination_table])
      end
      
      # single keyword
      if params[:keyword].present?
				keyword = params[:keyword].strip.downcase
				keyword.split(' ').each do |q|
					q = q.strip
					query = query.where('LOWER(gns_etl_mappings.source_table) LIKE ?', '%'+q.to_ascii.downcase+'%')
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
    
    # get options: source tables
    def self.source_tables
      log = Logger.new("log/etl_connect_db.log")
      
      begin
        tables = SourceDbBase.connection.tables
        # Add log to file log
        log.info "Get source tables: Connect to the source database successfully"
        options = tables.map {|t| {text: t, value: t}}
        return options
      rescue => e
        # Add log to file log
        log.error StandardError.new("#{e.message}")
      end
    end
    
    # get options: source field
    def self.source_fields(params)
      log = Logger.new("log/etl_connect_db.log")
      
      begin
        fields = SourceDbBase.connection.columns("#{params[:source_table]}").map(&:name)
        # Add log to file log
        log.info "Get source fields: Connect to the source database successfully"
        options = fields.map {|t| {text: t, value: t}}
        return options
      rescue => e
        # Add log to file log
        log.error StandardError.new("#{e.message}")
      end
    end
    
    # get options: destination tables
    def self.destination_tables
      log = Logger.new("log/etl_connect_db.log")
      
      begin
        tables = DestinationDbBase.connection.tables
        # Add log to file log
        log.info "Get destination tables: Connect to the destination database successfully"
        options = tables.map {|t| {text: t, value: t}}
        return options
      rescue => e
        # Add log to file log
        log.error StandardError.new("#{e.message}")
      end
    end
    
    # get options: destination field
    def self.destination_fields(params)
      log = Logger.new("log/etl_connect_db.log")
      options = []
      begin
        fields = DestinationDbBase.connection.columns("#{params[:destination_table]}").map(&:name)
        # Add log to file log
        log.info "Get destination fields: Connect to the destination database successfully"
        options = fields.map {|t| {text: t, value: t}}
      rescue => e
        # Add log to file log
        log.error StandardError.new("#{e.message}")
      end
      return options
    end
    
  end
end
