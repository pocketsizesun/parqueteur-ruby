# frozen_string_literal: true

module Parqueteur
  class ValueArrayBuilder
    attr_reader :type, :options, :arrow_type

    def self.build(input, type, options)
      new(type, options).build(input)
    end

    def initialize(type, options)
      @type = type
      @options = options
      @arrow_type = Parqueteur::TypeResolver.resolve(type, options)
    end

    def build(input)
      return if input.nil?

      case type
      when :array
        Arrow::ListArrayBuilder.build(arrow_type, input)
      when :map
        builder = Arrow::MapArrayBuilder.new(arrow_type)
        input.each do |entry|
          builder.append_value
          next if entry.nil?

          entry.each do |k, v|
            builder.key_builder.append(k)
            builder.item_builder.append(v)
          end
        end

        builder.finish
      when :boolean
        Arrow::BooleanArray.new(input)
      when :integer
        if options.fetch(:unsigned, false) == true
          Arrow::UInt32Array.new(input)
        else
          Arrow::Int32Array.new(input)
        end
      when :long
        if options.fetch(:unsigned, false) == true
          Arrow::UInt64Array.new(input)
        else
          Arrow::Int64Array.new(input)
        end
      when :string
        Arrow::StringArray.new(input)
      when :timestamp
        Arrow::TimestampArray.new(input)
      else
        raise Error, "unknown type: #{type}"
      end
    end
  end
end
