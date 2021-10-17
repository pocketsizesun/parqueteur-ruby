# frozen_string_literal: true

module Parqueteur
  module Types
    class Decimal128Type < Parqueteur::Type
      def initialize(options = {}, &block)
        @scale = options.fetch(:scale)
        @precision = options.fetch(:precision)
        @format_str = "%.#{@scale}f"
        super(options, &block)
      end

      def build_value_array(values)
        Arrow::Decimal128ArrayBuilder.build(
          @arrow_type,
          values.map do |value|
            Arrow::Decimal128.new(format(@format_str, BigDecimal(value)))
          end
        )
      end

      def arrow_type_builder
        Arrow::Decimal128DataType.new(
          @precision, @scale
        )
      end
    end
  end
end
