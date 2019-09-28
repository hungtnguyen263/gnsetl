class SourceDbBase < ActiveRecord::Base
  self.abstract_class = true
  establish_connection SOURCE_DB
  
  def self.create_table_db
    sql = 'CREATE TABLE company(MA_DTNT serial PRIMARY KEY, TEN_DTNT VARCHAR (50) UNIQUE NOT NULL, DIACHI VARCHAR (50) NOT NULL);'
    SourceDbBase.connection.exec_query(sql)
  end
  
  def self.insert_into_table
    sql = "INSERT INTO company (MA_DTNT, TEN_DTNT, DIACHI) VALUES ('1', 'Company name 1', 'Address 1'), ('2', 'Company name 2', 'Address 2'), ('3', 'Company name 3', 'Address 3'), ('4', 'Company name 4', 'Address 4'), ('5', 'Company name 5', 'Address 5'), ('6', 'Company name 6', 'Address 6'), ('7', 'Company name 7', 'Address 7'), ('8', 'Company name 8', 'Address 8'), ('9', 'Company name 9', 'Address 9'), ('10', 'Company name 10', 'Address 10'), ('11', 'Company name 11', 'Address 11'), ('12', 'Company name 12', 'Address 12'), ('13', 'Company name 13', 'Address 13'), ('14', 'Company name 14', 'Address 14'), ('15', 'Company name 15', 'Address 15'), ('16', 'Company name 16', 'Address 16'), ('17', 'Company name 17', 'Address 17'), ('18', 'Company name 18', 'Address 18'), ('19', 'Company name 19', 'Address 19'), ('20', 'Company name 20', 'Address 20')"
    SourceDbBase.connection.exec_query(sql)
  end
end