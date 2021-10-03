# frozen_string_literal: true

module Parqueteur
  module Types
    class Date32Type < Parqueteur::Type
      def build_value_array(values)
        Arrow::Date32ArrayBuilder.build(values)
      end

      def arrow_type_builder
        Arrow::Date32DataType.new
      end
    end
  end
end
