# frozen_string_literal: true

module Parqueteur
  module Types
    class MapType < Parqueteur::Type
      def build_value_array(values)
        builder = Arrow::MapArrayBuilder.new(arrow_type)
        values.each do |entry|
          builder.append_value
          next if entry.nil?

          entry.each do |k, v|
            builder.key_builder.append(k)
            builder.item_builder.append(v)
          end
        end

        builder.finish
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

