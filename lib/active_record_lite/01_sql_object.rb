require_relative 'db_connection'
require 'active_support/inflector'
#NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
#    of this project. It was only a warm up.

class SQLObject
  def self.columns
    prepare = "SELECT
    *
      FROM
        #{self.table_name}
    "
    result = DBConnection.execute2(prepare)
    result.first.map{ |value| value.to_sym }
  end

  def self.finalize!
    self.columns.each_with_index do |col, i|
      define_method "#{col}" do 
        self.attributes[col] 
      end
      define_method "#{col}=" do |param|
        self.attributes[col] = param 
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.inspect.to_s.downcase.pluralize  
  end

  def self.all
    query = "
    SELECT 
        #{self.table_name}.*
    FROM 
       #{self.table_name} 
       "
    result = DBConnection.execute(query)
    self.parse_all(result)
  end

  def self.parse_all(results)
    arr = []
    results.each do |hash|
      arr << self.new(hash)
    end
    arr
  end

  def self.find(id)
    query = "
    SELECT 
        *
    FROM 
       #{self.table_name} 
    WHERE 
       id = #{id}
       "
    result = DBConnection.execute(query)
    self.parse_all(result).first
  end

  def attributes
    @attributes ||= {}
  end


  def insert
    col_names = @attributes.keys
    str = ["?"]*col_names.length
    col_names = col_names.join(",")
    q_marks = str.join(", ")
    result = DBConnection.execute(<<-SQL, *attribute_values)
    INSERT INTO
          #{self.class.table_name} (#{col_names})
    VALUES
          (#{q_marks})
    SQL
  
  end

  def initialize(params={})
    params.each do |key,value| 
      key = key.to_sym
      unless self.class.columns.include?(key)
        raise StandardError.new("unknown attribute '#{key}'") 
      end
      self.send("#{key}=".to_sym, value)
    end
  end

  def save
    # ...
  end

  def update
    # ...
  end

  def attribute_values
    # calling Array#map on SQLObject::columns, calling send on the instance to get the value.
    attr_values = @attributes.keys.map{ |col_name| self.send(col_name) }
    attr_values
  end
end
