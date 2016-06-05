require_relative 'lib/foo_mangler'





require 'date'
def format_date(column_name, format)
  FooMangler::ColumnTransformation.new(column_name) do |raw|
    Date.parse(raw).strftime(format)
  end
end


input_file_name, output_file_name = ARGV

input = FooMangler::AsFile.new input_file_name, encoding: 'ISO-8859-1'
output = FooMangler::AsFile.new output_file_name

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

FooMangler::Mangler.new(
  parser: FooMangler::CSVParser.new(col_sep: ';'),
  transformation: format_date('Buchungsdatum', '%d-%m-%y'),
  dumper: FooMangler::CSVDumper.new('Buchungsdatum', nil, nil, 'Empfaenger 1', 'Verwendungszweck','Betrag', nil, nil, col_sep:';')
).mangle input, output
