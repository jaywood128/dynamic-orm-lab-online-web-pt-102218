require_relative "../config/environment.rb"
require 'active_support/inflector'
require 'pry'

class InteractiveRecord



  def self.table_name
    self.to_s.downcase.pluralize
  end

  def self.column_names
      DB[:conn].results_as_hash = true

      sql = "PRAGMA table_info ('#{table_name}')"

      table_info = DB[:conn].execute(sql)
      column_names = []
      table_info.each do |column|

        column_names << column["name"]
      end
      column_names.compact
    end
    self.column_names.each do |col_name|
      attr_accessor col_name.to_sym
    end

  def initialize(options = {}) #pass in a hash
    options.each do |key,value|
      self.send(("#{key}="),value)
    end
  end

  def table_name_for_insert
    self.class.table_name
  end

  def col_names_for_insert
    self.class.column_names.delete_if {|col| col == "id"}.join(', ')
  end

  def values_for_insert
    values = []
    self.class.column_names.each do |col_name|

      values << "'#{send(col_name)}'" unless send(col_name).nil?
    end
    values.join(", ")
    
  end

end
