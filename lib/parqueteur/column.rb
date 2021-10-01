# frozen_string_literal: true

module Parqueteur
  class Column
    attr_reader :name, :type, :options

    def initialize(name, type, options = {})
      @name = name.to_s
      @type = type
      @options = options
    end

    def arrow_type
      @arrow_type ||= Parqueteur::TypeResolver.resolve(@type, @options)
    end

    def cast(value)
      case @type
      when :string then value.to_s
      when :boolean then value == true
      when :integer then value.to_i
      when :long then value.to_i
      when :timestamp
        case value
        when String then Time.parse(value).to_i
        when Integer then value
        else
          raise ArgumentError, "Unable to cast '#{value}' to timestamp"
        end
      when :map then value
      end
    end

    def to_arrow_field
      Arrow::Field.new(name, arrow_type)
    end
  end
end
