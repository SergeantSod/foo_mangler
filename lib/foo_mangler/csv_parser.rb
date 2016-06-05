require 'csv'

module FooMangler
  class CSVParser

    attr_reader :options

    def initialize(options={})
      @options=options
    end

    def parse(io)
      CSV.new(io, **options, headers: true).map(&:to_h)
    end

  end
end
