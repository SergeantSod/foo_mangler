require 'csv'

module FooMangler
  class CSVDumper

    attr_reader :columns, :options

    def initialize(*columns, **options)
      @columns = columns
      @options = options
    end

    def dump(rows, io)
      rows.each do |row|
        io.puts dump_line(row)
      end
    end

    private

    def row_to_array(row)
      columns.map do |column|
        row[column]
      end
    end

    def dump_line(row)
      CSV.generate_line row_to_array(row), options
    end
  end
end
