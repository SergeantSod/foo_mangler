$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pry'
require 'tempfile'
require 'open3'

require 'foo_mangler'


def relative_path(*relative_path_fragments)
  File.expand_path File.join(__dir__, *relative_path_fragments)
end

def fixture_path(file_name)
  relative_path('fixtures', file_name)
end

def with_temp_file(&block)
  Tempfile.open("temp_output") do |file|
    block.call file.path
  end
end

def runner_path
  relative_path '..', 'exe', 'foo_mangler'
end

def invoke_runner(*runner_arguments)
  stdout, stderr, status = Open3.capture3(runner_path, *runner_arguments)
  unless status.success?
  # TODO Improve the error message. Maybe even extract another matcher
  raise """
          Runner failed, with exit status #{status.to_i}
          Standard output:
          ===================
          #{stdout}
          ===================
          Standard error:
          #{stderr}
        """
  end
end


#TODO Extract the matcher and its factory method into a module that is mixed into Rspec via .configure.
class HaveSameContents

  attr_reader :expected, :actual
  def initialize(expected_file_name)
    @expected = File.read expected_file_name
  end

  def matches?(actual_file_name)
    @actual = File.read actual_file_name
    expected == actual
  end

  def failure_message
    "expected same file contents, but found differences"
  end

  def failure_message_when_negated
    "expected different file contents, but files where the same"
  end

  def diffable?
    true
  end

end

def have_same_contents(*args)
  HaveSameContents.new(*args)
end
