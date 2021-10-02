# frozen_string_literal: true

module Parqueteur
  class Column
    attr_reader :name, :type, :options

    def initialize(name, type, options = {}, &block)
      @name = name.to_s
      @type = Parqueteur::TypeResolver.resolve(type, options, &block)
      @options = options
    end

    def arrow_type
      @type.arrow_type
    end

    def to_arrow_field
      Arrow::Field.new(name, arrow_type)
    end
  end
end
