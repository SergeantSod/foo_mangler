# argument input_file_name: String, output_file_name: String

mapping do
  input  file input_file_name, encoding: 'ISO-8859-1'
  output file output_file_name

  from csv_reader col_sep: ';'
  to   csv_dumper 'Buchungsdatum', :empty, :empty, 'Empfaenger 1', 'Verwendungszweck','Betrag', :empty, :empty, col_sep:';'

  use format_date 'Buchungsdatum', '%d-%m-%y'
end
