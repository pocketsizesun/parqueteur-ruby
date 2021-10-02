# frozen_string_literal: true

# when :timestamp
#   Arrow::TimestampDataType.new(
#     options.fetch(:unit, :second)
#   )

module Parqueteur
  module Types
    class StructType < Parqueteur::Type
      def build_value_array(values)
        values.each do |value|
          next if value.nil?

          value.each_key do |key|
            next if struct_object.key?(key)

            raise Parqueteur::Error, "Struct field '#{key}' not found"
          end
        end
        Arrow::StructArrayBuilder.build(arrow_type, values)
      end

      def arrow_type_builder
        Arrow::StructDataType.new(struct_object.to_arrow_type)
      end

      private

      def struct_object
        @struct_object ||= Parqueteur::Struct.new(&@block)
      end
    end
  end
end
