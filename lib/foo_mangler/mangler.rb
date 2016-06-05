module FooMangler
  class Mangler

    attr_reader :parser, :dumper, :transformation

    def initialize(parser:, dumper:, transformation: ComposedTransformation.new)
      @parser = parser
      @dumper = dumper
      @transformation = transformation
    end

    def mangle(input, output)
      input.open_reader do |reader|
        output.open_writer do |writer|
          parsed_rows = parser.parse(reader)
          transformed_rows = apply_transformation parsed_rows
          dumper.dump(transformed_rows, writer)
        end
      end
    end

    private

    def apply_transformation(rows)
      rows.map do |row|
        transformation.call row
      end
    end

  end
end
