# frozen_string_literal: true

module Parqueteur
  module Types
    class Decimal256Type < Parqueteur::Type
      def initialize(options = {}, &block)
        @scale = options.fetch(:scale)
        @precision = options.fetch(:precision)
        @format_str = "%.#{@scale}f"
        super(options, &block)
      end

      def build_value_array(values)
        Arrow::Decimal256ArrayBuilder.build(
          @arrow_type,
          values.map do |value|
            Arrow::Decimal256.new(format(@format_str, BigDecimal(value)))
          end
        )
      end

      def arrow_type_builder
        Arrow::Decimal256DataType.new(
          @precision, @scale
        )
      end
    end
  end
end
