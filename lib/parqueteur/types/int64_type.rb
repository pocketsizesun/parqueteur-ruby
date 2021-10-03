# frozen_string_literal: true

module Parqueteur
  module Types
    class Int64Type < Parqueteur::Type
      def build_value_array(values)
        if options.fetch(:unsigned, false) == true
          Arrow::UInt64Array.new(values)
        else
          Arrow::Int64Array.new(values)
        end
      end

      def arrow_type_builder
        if options.fetch(:unsigned, false) == true
          Arrow::UInt64DataType.new
        else
          Arrow::Int64DataType.new
        end
      end
    end
  end
end
