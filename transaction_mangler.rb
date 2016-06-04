require 'pry'

class Mangler

  attr_reader :parser, :dumper, :transformation

  def initialize(parser:, dumper:, transformation: Composed.new)
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

  def apply_transformation(rows)
    rows.map do |row|
      transformation.call row
    end
  end

end

require 'csv'
class CSVParser

  attr_reader :options

  def initialize(options={})
    @options=options
  end

  def parse(io)
    CSV.new(io, **options, headers: true).map(&:to_h)
  end
end

class AsFile

  attr_reader :file_name, :encoding

  def initialize(file_name, encoding: 'UTF-8')
    @file_name = file_name
    @encoding = encoding
  end

  def open_reader(&reading_block)
    File.open(file_name, "r:#{encoding}", &reading_block)
  end

  def open_writer(&writing_block)
    File.open(file_name, "w:#{encoding}", &writing_block)
  end
end

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

class Composed

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

require 'date'
def format_date(column_name, format)
  ColumnTransformation.new(column_name) do |raw|
    Date.parse(raw).strftime(format)
  end
end


input_file_name, output_file_name = ARGV

input = AsFile.new input_file_name, encoding: 'ISO-8859-1'
output = AsFile.new output_file_name

# http://homebank.free.fr/help/misc-csvformat.html
#
# date	format must be DD-MM-YY
# paymode	from 0=none to 10=FI fee
# info	a string
# payee	a payee name
# memo	a string
# amount	a number with a '.' or ',' as decimal separator, ex: -24.12 or 36,75
# category	a full category name (category, or category:subcategory)
# tags	tags separated by space
# tag is mandatory since v4.5

Mangler.new(
  parser: CSVParser.new(col_sep: ';'),
  transformation: format_date('Buchungsdatum', '%d-%m-%y'),
  dumper: CSVDumper.new('Buchungsdatum', nil, nil, 'Empfaenger 1', 'Verwendungszweck','Betrag', nil, nil, col_sep:';')
).mangle input, output
