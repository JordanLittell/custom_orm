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
    # ...
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def attributes
    @attributes ||= {}
  end

  def insert
    # ...
  end

  def initialize
    # ...
  end

  def save
    # ...
  end

  def update
    # ...
  end

  def attribute_values
    # ...
  end
end
