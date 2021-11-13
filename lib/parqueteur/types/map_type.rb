# frozen_string_literal: true

module Parqueteur
  module Types
    class MapType < Parqueteur::Type
      def build_value_array(values)
        Arrow::MapArrayBuilder.build(arrow_type, values)
      end

      def arrow_type_builder
        map_value = options.fetch(:value)

        Arrow::MapDataType.new(
          resolve(options.fetch(:key)).arrow_type,
          if map_value.is_a?(Hash)
            resolve(map_value.fetch(:type), map_value).arrow_type
          else
            resolve(map_value).arrow_type
          end
        )
      end
    end
  end
end

