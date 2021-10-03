# frozen_string_literal: true

module Parqueteur
  module Types
    class Time64Type < Parqueteur::Type
      def build_value_array(values)
        Arrow::Time64Array.new(
          @options.fetch(:precision, :second), values
        )
      end

      def arrow_type_builder
        Arrow::Time64DataType.new(
          options.fetch(:unit, :second)
        )
      end
    end
  end
end
