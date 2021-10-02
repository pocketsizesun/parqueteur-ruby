require 'bundler/setup'
require 'parqueteur'

class FooParquetConverter < Parqueteur::Converter
  column :id, :bigint
  column :reference, :string
end

data = [
  { 'id' => 1, 'reference' => 'hello world 1' },
  { 'id' => 2, 'reference' => 'hello world 2' },
  { 'id' => 3, 'reference' => 'hello world 3' }
]

FooParquetConverter.convert_to(data, 'tmp/hello_world.parquet')
