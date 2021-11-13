# frozen_string_literal: true

module Parqueteur
  class Converter
    DEFAULT_BATCH_SIZE = 100

    def self.inline(&block)
      Class.new(self, &block)
    end

    def self.columns
      @columns ||= Parqueteur::ColumnCollection.new
    end

    def self.column(name, type, options = {}, &block)
      columns.add(Parqueteur::Column.new(name, type, options, &block))
    end

    def self.transforms
      @transforms ||= []
    end

    def self.transform(method_name = nil, &block)
      transforms << (method_name || block)
    end

    def self.convert(input, **kwargs)
      new(input, **kwargs).to_io
    end

    def self.convert_to(input, output_path, **kwargs)
      converter = new(input, **kwargs)
      converter.write(output_path)
    end

    # @param [Enumerable] An enumerable object
    # @option [Symbol] compression - :gzip
    def initialize(input, **kwargs)
      @input = Parqueteur::Input.from(input)
      @batch_size = kwargs.fetch(:batch_size, DEFAULT_BATCH_SIZE)
      @compression = kwargs.fetch(:compression, nil)&.to_sym
    end

    def split(size, batch_size: nil, compression: nil)
      Enumerator.new do |arr|
        options = {
          batch_size: batch_size || @batch_size,
          compression: compression || @compression
        }
        @input.each_slice(size) do |records|
          local_converter = self.class.new(records, **options)
          file = local_converter.to_tmpfile
          arr << file
          file.close
          file.unlink
        end
      end
    end

    def split_by_io(size, batch_size: nil, compression: nil)
      Enumerator.new do |arr|
        options = {
          batch_size: batch_size || @batch_size,
          compression: compression || @compression
        }
        @input.each_slice(size) do |records|
          local_converter = self.class.new(records, **options)
          arr << local_converter.to_io
        end
      end
    end

    def write(path, batch_size: nil, compression: nil)
      compression = @compression if compression.nil?
      batch_size = @batch_size if batch_size.nil?
      arrow_schema = self.class.columns.arrow_schema
      writer_properties = Parquet::WriterProperties.new
      if !compression.nil? && compression != false
        writer_properties.set_compression(compression)
      end

      Arrow::FileOutputStream.open(path, false) do |output|
        Parquet::ArrowFileWriter.open(arrow_schema, output, writer_properties) do |writer|
          @input.each_slice(batch_size) do |records|
            arrow_table = build_arrow_table(records)
            writer.write_table(arrow_table, 1024)
          end
        end
      end

      true
    end

    def to_tmpfile(options = {})
      tempfile = Tempfile.new
      tempfile.binmode
      write(tempfile.path, **options)
      tempfile.rewind
      tempfile
    end

    def to_io(options = {})
      tmpfile = to_tmpfile(options)
      strio = StringIO.new(tmpfile.read)
      tmpfile.close
      tmpfile.unlink
      strio
    end

    def to_arrow_table(options = {})
      file = to_tmpfile(options)
      table = Arrow::Table.load(file.path, format: :parquet)
      file.close
      file.unlink
      table
    end

    def to_blob(options = {})
      to_tmpfile(options).read
    end

    private

    def build_arrow_table(records)
      transforms = self.class.transforms

      values = self.class.columns.each_with_object({}) do |column, hash|
        hash[column.name] = []
      end

      records.each do |item|
        if transforms.length > 0
          transforms.each do |transform|
            item = \
              if transform.is_a?(Symbol)
                __send__(transform, item)
              else
                transform.call(item)
              end
          end
        end

        values.each_key do |value_key|
          if item.key?(value_key)
            values[value_key] << item[value_key]
          else
            values[value_key] << nil
          end
        end
      end

      Arrow::Table.new(
        values.each_with_object({}) do |item, hash|
          column = self.class.columns.find(item[0])
          hash[item[0]] = column.type.build_value_array(item[1])
        end
      )
    end
  end
end
