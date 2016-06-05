module FooMangler
  class Configuration < BasicObject

    class Mapping < BasicObject

      attr_reader :input_file_name, :output_file_name

      def initialize(input_file_name, output_file_name, &definition)
        @input_file_name = input_file_name
        @output_file_name = output_file_name
        @transformations = []
        instance_eval &definition
      end

      def file(*args)
        ::FooMangler::AsFile.new *args
      end

      def csv_reader(*args)
        ::FooMangler::CSVParser.new *args
      end

      def csv_dumper(*args)
        ::FooMangler::CSVDumper.new *args
      end

      def input(i)
        @input = i
      end

      def output(o)
        @output = o
      end

      def use(transformation)
        @transformations << transformation
      end

      def from(parser)
        @parser = parser
      end

      require 'date'
      def format_date(column_name, format)
        ::FooMangler::ColumnTransformation.new(column_name) do |raw|
          ::Date.parse(raw).strftime(format)
        end
      end

      def use(transformation)
        @transformations << transformation
      end

      def to(dumper)
        @dumper = dumper
      end

      def defined_input
        @input
      end

      def defined_output
        @output
      end

      def to_h
        {
          parser: @parser,
          dumper: @dumper,
          transformation: ::FooMangler::ComposedTransformation.new(*@transformations)
        }
      end

    end

    def self.load(file_name, **options)
      new(**options, definition: ::File.read(file_name))
    end

    def initialize(definition: nil, input_file_name:, output_file_name:, &definition_block)
      @input_file_name = input_file_name
      @output_file_name = output_file_name
      raise ArgumentError unless definition_block.nil? ^ definition.nil?
      instance_eval definition, &definition_block
    end

    def mapping(&block)
      @defined_mapping = Mapping.new @input_file_name, @output_file_name, &block
    end

    def defined_mapping
      @defined_mapping || raise('No mapping defined in config.')
    end

    def mangler
      ::FooMangler::Mangler.new(**defined_mapping.to_h)
    end

    def input
      defined_mapping.defined_input
    end

    def output
      defined_mapping.defined_output
    end

  end
end
