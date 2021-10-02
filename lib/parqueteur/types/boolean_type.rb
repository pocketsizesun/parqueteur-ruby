# frozen_string_literal: true

module Parqueteur
  module Types
    class BooleanType < Parqueteur::Type
      def build_value_array(values)
        Arrow::BooleanArray.new(values)
      end

      def arrow_type_builder
        Arrow::BooleanDataType.new
      end
    end
  end
end
