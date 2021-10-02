# frozen_string_literal: true

require 'json'
require 'singleton'

require_relative "parqueteur/version"
require 'parqueteur/chunked_converter'
require 'parqueteur/column'
require 'parqueteur/column_collection'
require 'parqueteur/converter'
require 'parqueteur/input'
require 'parqueteur/struct'
require 'parqueteur/type'
require 'parqueteur/type_resolver'
require 'parqueteur/types/array_type'
require 'parqueteur/types/boolean_type'
require 'parqueteur/types/int32_type'
require 'parqueteur/types/int64_type'
require 'parqueteur/types/map_type'
require 'parqueteur/types/string_type'
require 'parqueteur/types/struct_type'
require 'parqueteur/types/timestamp_type'
require 'parquet'

module Parqueteur
  class Error < StandardError; end
  class TypeNotFound < Error; end
  # Your code goes here...
end
