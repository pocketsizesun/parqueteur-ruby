# frozen_string_literal: true

module Parqueteur
  module Types
    class Int32Type < Parqueteur::Type
      def build_value_array(values)
        if options.fetch(:unsigned, false) == true
          Arrow::UInt32Array.new(values)
        else
          Arrow::Int32Array.new(values)
        end
      end

      def arrow_type_builder
        if options.fetch(:unsigned, false) == true
          Arrow::UInt32DataType.new
        else
          Arrow::Int32DataType.new
        end
      end
    end
  end
end

# when :integer
