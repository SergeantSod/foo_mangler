$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pry'
require 'tempfile'
require 'foo_mangler'


def fixture_path(file_name)
  File.expand_path(file_name, "#{__FILE__}/../fixtures")
end

def with_temp_file(&block)
  Tempfile.open("temp_output") do |file|
    block.call file.path
  end
end
