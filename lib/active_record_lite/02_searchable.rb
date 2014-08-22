require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    where_clause = params.keys.map{ |key| "#{key} = ?" }.join(" AND ")
    attribute_values = params.values
    result = DBConnection.execute(<<-SQL, *attribute_values)
    SELECT
          *
    FROM 
    	#{self.table_name}
    WHERE
          #{where_clause}
    SQL
    parse_all result
  end
end

class SQLObject
  extend Searchable
end
