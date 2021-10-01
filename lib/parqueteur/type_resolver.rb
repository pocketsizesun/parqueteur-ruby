# frozen_string_literal: true

module Parqueteur
  class TypeResolver
    def self.resolve(*args)
      new.resolve(*args)
    end

    def resolve(type, options = {})
      case type
      when :array
        elements_opt = options.fetch(:elements)
        Arrow::ListDataType.new(
          if elements_opt.is_a?(Hash)
            resolve(elements_opt.fetch(:type), elements_opt)
          else
            resolve(elements_opt)
          end
        )
      when :boolean
        Arrow::BooleanDataType.new
      when :integer
        if options.fetch(:unsigned, false) == true
          Arrow::UInt32DataType.new
        else
          Arrow::Int32DataType.new
        end
      when :long
        if options.fetch(:unsigned, false) == true
          Arrow::UInt64DataType.new
        else
          Arrow::Int64DataType.new
        end
      when :timestamp
        Arrow::TimestampDataType.new(
          options.fetch(:unit, :second)
        )
      when :string
        Arrow::StringDataType.new
      when :map
        map_value = options.fetch(:value)
        Arrow::MapDataType.new(
          resolve(options.fetch(:key)),
          if map_value.is_a?(Hash)
            resolve(map_value.fetch(:type), map_value)
          else
            resolve(map_value)
          end
        )
      else
        raise Error, "unknown type: #{type}"
      end
    end
  end
end

private

def build_arrow_type(type, options = {})

end
