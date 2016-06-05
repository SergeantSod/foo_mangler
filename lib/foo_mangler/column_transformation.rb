module FooMangler
  
  class ColumnTransformation

    attr_reader :column_name, :value_transformation

    def initialize(column_name, &value_transformation)
      @column_name = column_name
      @value_transformation = value_transformation
    end

    def call(row)
      new_value = value_transformation.call row[column_name]
      row.merge column_name => new_value
    end

  end

end
