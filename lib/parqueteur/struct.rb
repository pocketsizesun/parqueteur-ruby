# frozen_string_literal: true

module Parqueteur
  class Struct
    def initialize(&block)
      instance_exec(&block)
    end

    def fields
      @fields ||= Parqueteur::ColumnCollection.new
    end

    def field(name, type, options = {}, &block)
      fields.add(Parqueteur::Column.new(name, type, options, &block))
    end

    def key?(key)
      fields.key?(key)
    end

    def to_arrow_type
      fields.collect(&:to_arrow_field)
    end
  end
end
