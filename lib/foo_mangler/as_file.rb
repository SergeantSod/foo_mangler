module FooMangler

  #TODO Rename
  #TODO Rethink the decision to have reading and writing in one.
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
end
