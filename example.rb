require 'bundler/setup'
require 'parqueteur'

class Foo < Parqueteur::Converter
  column :id, :bigint
  column :reference, :string
  column :hash, :map, key: :string, value: :string
  column :valid, :boolean
  column :total, :integer
  column :numbers, :array, elements: :integer
  column :my_struct, :struct do
    field :test, :string
    field :mon_nombre, :integer
  end
end

LETTERS = ('a'..'z').to_a

data = 1000.times.collect do |i|
  {
    'id' => i + 1,
    'reference' => "coucou:#{i}",
    'hash' => { 'a' => LETTERS.sample },
    'valid' => rand < 0.5,
    'total' => rand(100..500),
    'numbers' => [1, 2, 3],
    'my_struct' => {
      'test' => 'super'
    }
  }
end

# chunked_converter = Parqueteur::ChunkedConverter.new(data, Foo)
# pp chunked_converter.write_files('test')
puts Foo.convert(data, output: 'tmp/test.parquet')
table = Arrow::Table.load('tmp/test.parquet')
table.each_record do |record|
  puts record.to_h
end
