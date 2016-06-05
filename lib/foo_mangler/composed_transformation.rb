module FooMangler

  class ComposedTransformation

    attr_reader :transformations

    def initialize(*transformations)
      @transformations = transformations
    end

    def call(input_row)
      transformations.inject(input_row) do |current_value, next_transformation|
        next_transformation.call current_value
      end
    end
  end

end
