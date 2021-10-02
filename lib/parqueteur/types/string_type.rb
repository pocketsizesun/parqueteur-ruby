# frozen_string_literal: true

# when :timestamp
#   Arrow::TimestampDataType.new(
#     options.fetch(:unit, :second)
#   )

module Parqueteur
  module Types
    class StringType < Parqueteur::Type
      def build_value_array(values)
        Arrow::StringArray.new(values)
      end

      def arrow_type_builder
        Arrow::StringDataType.new
      end
    end
  end
end
