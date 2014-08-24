require_relative '03_associatable'

# Phase V
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
    define_method "#{name}" do
    through_options = self.class.assoc_options[through_name] 
   	source_options = through_options.model_class.assoc_options[source_name]
   	source_table = "#{ source_options.table_name }"
   	through_table = "#{ through_options.table_name}"
   	first_belongs = self.send(through_options.class_name.to_s.downcase.to_sym)
   	result = DBConnection.execute(<<-SQL, first_belongs.send(through_options.primary_key))
   		SELECT #{ source_table }.* 
   		FROM 
   			#{through_table} 
 		JOIN 
 			#{source_table}
 		ON 
 			#{through_table}.#{ source_options.foreign_key } = #{source_table}.#{ source_options.primary_key }
 		WHERE 
 			#{ through_table }.id = ?
   	SQL
   	source_options.model_class.send(:new, result.first)
   	
    end
  end
end
