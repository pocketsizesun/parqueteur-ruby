# frozen_string_literal: true

module Parqueteur
  module Types
    class Decimal128Type < Parqueteur::Type
      def build_value_array(values)
        Arrow::Decimal128ArrayBuilder.build(@arrow_type, values)
      end

      def arrow_type_builder
        Arrow::Decimal128DataType.new(
          precision: @options.fetch(:precision),
          scale: @options.fetch(:scale)
        )
      end
    end
  end
end
