# frozen_string_literal: true

module Parqueteur
  class Type
    attr_reader :options, :arrow_type

    def initialize(options = {}, &block)
      @options = options
      @block = block
      @arrow_type = arrow_type_builder
    end

    def build_value_array(values)
      raise "#to_arrow_field must be implemented in #{self.class}"
    end

    def resolve(type, options = {})
      Parqueteur::TypeResolver.resolve(type, options)
    end
  end
end
