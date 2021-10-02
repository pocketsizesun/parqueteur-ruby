# frozen_string_literal: true

module Parqueteur
  class ColumnCollection
    include Enumerable

    attr_reader :column_names

    def initialize
      @columns = []
      @column_names = []
      @columns_idx = {}
    end

    def key?(key)
      @columns_idx.key?(key)
    end

    def each(&block)
      @columns.each(&block)
    end

    def add(column)
      unless @columns_idx.key?(column.name)
        @columns_idx[column.name] = column
        @columns << column
        @column_names << column.name
      end

      true
    end

    def find(name)
      @columns_idx.fetch(name, nil)
    end

    def arrow_schema
      @arrow_schema ||= Arrow::Schema.new(@columns.collect(&:to_arrow_field))
    end
  end
end
