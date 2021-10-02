# frozen_string_literal: true

# when :timestamp
#   Arrow::TimestampDataType.new(
#     options.fetch(:unit, :second)
#   )

module Parqueteur
  module Types
    class TimestampType < Parqueteur::Type
      def build_value_array(values)
        Arrow::TimestampArray.new(values)
      end

      def arrow_type_builder
        Arrow::TimestampDataType.new(
          options.fetch(:unit, :second)
        )
      end
    end
  end
end
