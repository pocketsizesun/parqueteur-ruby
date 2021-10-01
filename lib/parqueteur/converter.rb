# frozen_string_literal: true

module Parqueteur
  class Converter
    attr_reader :schema

    def self.inline(&block)
      Class.new(self, &block)
    end

    def self.columns
      @columns ||= Parqueteur::ColumnCollection.new
    end

    def self.column(name, type, options = {})
      columns.add(Parqueteur::Column.new(name, type, options))
    end

    def self.transforms
      @transforms ||= []
    end

    def self.transform(method_name, &block)
      transforms << (method_name || block)
    end

    def self.convert(input, output: nil)
      converter = new(input)
      if !output.nil?
        converter.write(output)
      else
        converter.to_blob
      end
    end

    def initialize(input, options = {})
      @input = Parqueteur::Input.from(input, options)
    end

    def write(output)
      case output
      when :io
        to_io
      when String
        to_arrow_table.save(output)
      when StringIO, IO
        buffer = Arrow::ResizableBuffer.new(0)
        to_arrow_table.save(buffer, format: :parquet)
        output.write(buffer.data.to_s)
        output.rewind
        output
      else
        raise ArgumentError, "unsupported output: #{output.class}, accepted: String (filename), IO, StringIO"
      end
    end

    def to_s
      inspect
    end

    def to_io
      write(StringIO.new)
    end

    def to_blob
      write(StringIO.new).read
    end

    def to_arrow_table
      values = self.class.columns.each_with_object({}) do |column, hash|
        hash[column.name] = []
      end

      transforms = self.class.transforms

      @input.each do |item|
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

      transformed_values = values.each_with_object({}) do |item, hash|
        column = self.class.columns.find(item[0])
        hash[item[0]] = Parqueteur::ValueArrayBuilder.build(
          item[1], column.type, column.options
        )
      end
      Arrow::Table.new(transformed_values)
    end
  end
end
