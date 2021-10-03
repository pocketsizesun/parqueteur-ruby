# frozen_string_literal: true

module Parqueteur
  module Types
    class Decimal256Type < Parqueteur::Type
      def build_value_array(values)
        Arrow::Decimal256ArrayBuilder.build(@arrow_type, values)
      end

      def arrow_type_builder
        Arrow::Decimal256DataType.new(
          precision: @options.fetch(:precision),
          scale: @options.fetch(:scale)
        )
      end
    end
  end
end
