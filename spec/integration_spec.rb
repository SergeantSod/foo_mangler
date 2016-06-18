require 'spec_helper'

describe 'transformation from a csv file to another' do
  it 'writes the correct csv contents to the output file' do
    with_temp_file do |output_file|
      invoke_runner fixture_path('mapping.rb'), fixture_path('input.csv'), output_file
      expect(output_file).to have_same_contents fixture_path('expected_output.csv')
    end
  end
end
