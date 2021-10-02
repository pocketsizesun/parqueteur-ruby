# frozen_string_literal: true

module Parqueteur
  class TypeResolver
    include Singleton

    def self.registered_types
      @registered_types ||= {
        array: Parqueteur::Types::ArrayType,
        bigdecimal: Parqueteur::Types::Decimal256Type,
        bigint: Parqueteur::Types::Int64Type,
        boolean: Parqueteur::Types::BooleanType,
        decimal: Parqueteur::Types::Decimal128Type,
        decimal128: Parqueteur::Types::Decimal128Type,
        decimal256: Parqueteur::Types::Decimal256Type,
        int32: Parqueteur::Types::Int32Type,
        int64: Parqueteur::Types::Int64Type,
        integer: Parqueteur::Types::Int32Type,
        map: Parqueteur::Types::MapType,
        string: Parqueteur::Types::StringType,
        struct: Parqueteur::Types::StructType,
        timestamp: Parqueteur::Types::TimestampType
      }
    end

    def self.register_type(type, klass)
      registered_types[type] = klass
    end

    def self.resolve(*args, &block)
      instance.resolve(*args, &block)
    end

    def resolve(type, options = {}, &block)
      if type.is_a?(Symbol)
        resolve_from_symbol(type, options, &block)
      else
        type.new(options, &block)
      end
    end

    private

    def resolve_from_symbol(type, options, &block)
      type_klass = self.class.registered_types.fetch(type.to_sym, nil)
      raise Parqueteur::TypeNotFound, type if type_klass.nil?

      type_klass.new(options, &block)
    end
  end
end
