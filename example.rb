require 'bundler/setup'
require 'parqueteur'

class Foo < Parqueteur::Converter
  column :id, :long
  column :reference, :string
  column :hash, :map, key: :string, value: :string
  column :valid, :boolean
  column :total, :integer
end

LETTERS = ('a'..'z').to_a

data = 1000.times.collect do |i|
  { 'id' => i + 1, 'reference' => "coucou:#{i}", 'hash' => { 'a' => LETTERS.sample }, 'valid' => rand < 0.5, 'total' => rand(100..500) }
end

chunked_converter = Parqueteur::ChunkedConverter.new(data, Foo)
pp chunked_converter.write_files('test')
# puts Foo.convert(data, output: 'test.parquet')
