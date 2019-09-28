class DestinationDbBase < ActiveRecord::Base
  self.abstract_class = true
  establish_connection DESTINATION_DB
  
  def self.create_table_db
    sql = 'CREATE TABLE COMPANY(CODE VARCHAR (10) PRIMARY KEY, NAME VARCHAR (50) UNIQUE NOT NULL, DIACHI VARCHAR (50) NOT NULL);'
    DestinationDbBase.connection.exec_query(sql)
  end
end