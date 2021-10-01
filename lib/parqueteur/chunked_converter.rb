# frozen_string_literal: true

module Parqueteur
  class ChunkedConverter
    attr_reader :schema

    def initialize(input, converter, chunk_size = 200)
      @input = Parqueteur::Input.from(input)
      @converter = converter
      @chunk_size = chunk_size
    end

    def chunks
      Enumerator.new do |arr|
        @input.each_slice(@chunk_size) do |chunk|
          local_converter = @converter.new(chunk)
          arr << local_converter.to_io
        end
      end
    end

    def write_files(prefix)
      chunks.each_with_index do |chunk, idx|
        File.write("#{prefix}.#{idx}.parquet", chunk.read)
      end
    end
  end
end
