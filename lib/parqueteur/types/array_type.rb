# frozen_string_literal: true

module Parqueteur
  module Types
    class ArrayType < Parqueteur::Type
      def build_value_array(values)
        Arrow::ListArrayBuilder.build(arrow_type, values)
      end

      def arrow_type_builder
        Arrow::ListDataType.new(
          if options[:elements].is_a?(Hash)
            resolve(options[:elements].fetch(:type), options[:elements]).arrow_type
          else
            resolve(options[:elements]).arrow_type
          end
        )
      end
    end
  end
end
