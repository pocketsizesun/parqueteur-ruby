# frozen_string_literal: true

require 'json'
require 'singleton'
require 'tempfile'
require 'parquet'

require_relative 'parqueteur/version'
require 'parqueteur/column'
require 'parqueteur/column_collection'
require 'parqueteur/converter'
require 'parqueteur/input'
require 'parqueteur/struct'
require 'parqueteur/type'
require 'parqueteur/type_resolver'
require 'parqueteur/types/array_type'
require 'parqueteur/types/boolean_type'
require 'parqueteur/types/date32_type'
require 'parqueteur/types/date64_type'
require 'parqueteur/types/decimal128_type'
require 'parqueteur/types/decimal256_type'
require 'parqueteur/types/int32_type'
require 'parqueteur/types/int64_type'
require 'parqueteur/types/map_type'
require 'parqueteur/types/string_type'
require 'parqueteur/types/struct_type'
require 'parqueteur/types/time32_type'
require 'parqueteur/types/time64_type'
require 'parqueteur/types/timestamp_type'

module Parqueteur
  class Error < StandardError; end
  class TypeNotFound < Error; end
end
