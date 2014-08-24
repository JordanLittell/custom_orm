require_relative '02_searchable'
require 'active_support/inflector'

# Phase IVa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    model_class.send(:table_name)
  end
end

class BelongsToOptions < AssocOptions

  def initialize(name, options = {})
    @foreign_key = "#{name}_id".to_sym
    @primary_key = :id
    @class_name = "#{name.to_s.camelcase}"
    if options
      options.each do |key, value|
        instance_variable_set("@#{key}", value) 
        instance_variable_get("@#{key}")
      end
    end
  end

end

class HasManyOptions < AssocOptions
  attr_accessor :foreign_key
  def initialize(name, self_class_name, options = {})
    @foreign_key = "#{self_class_name.to_s.downcase}_id".to_sym
    @primary_key = :id
    @class_name = "#{name.to_s.singularize.camelcase}"
  
    options.each do |key, value|
      next if key.nil? || value.nil? 
      instance_variable_set("@#{key.to_s}", value)
      instance_variable_get("@#{key.to_s}")
    end
    p "the options are #{@class_name} and #{options[:class_name]}"
  end
end

module Associatable
  # Phase IVb
  # .
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name,options)
    
    define_method "#{name}" do 
      #get the target class (done) 
      #pull data out from row w/ primary key that matches foreign_key
      options.model_class.where(
        { :id => self.send(options.foreign_key.to_s) }
      ).first
    end

  end

  def has_many(name, options = {})
    # ...
  end

  def assoc_options
    # Wait to implement this in Phase V. Modify `belongs_to`, too.
  end
end

class SQLObject
  extend Associatable
end
