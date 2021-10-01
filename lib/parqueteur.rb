# frozen_string_literal: true

require_relative "parqueteur/version"
require 'parqueteur/type_resolver'
require 'parqueteur/column'
require 'parqueteur/column_collection'
require 'parqueteur/converter'
require 'parqueteur/chunked_converter'
require 'parqueteur/input'
require 'parqueteur/value_array_builder'
require 'json'
require 'parquet'

module Parqueteur
  class Error < StandardError; end
  # Your code goes here...
end
