# frozen_string_literal: true

module Parqueteur
  module Types
    class Date64Type < Parqueteur::Type
      def build_value_array(values)
        Arrow::Date64ArrayBuilder.build([values])
      end

      def arrow_type_builder
        Arrow::Date64DataType.new
      end
    end
  end
end
