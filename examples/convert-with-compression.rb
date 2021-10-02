require 'bundler/setup'
require 'parqueteur'
require 'securerandom'
require 'benchmark'

class Foo < Parqueteur::Converter
  column :id, :bigint
  column :reference, :string
  column :hash, :map, key: :string, value: :string
  # column :hash2, :map, key: :string, value: :string
  # column :hash3, :map, key: :string, value: :string
  column :valid, :boolean
  column :total, :integer
  column :numbers, :array, elements: :integer
  column :my_struct, :struct do
    field :test, :string
    field :mon_nombre, :integer
  end
end

def random_hash
  {
    'a' => SecureRandom.hex(128),
    'b' => SecureRandom.hex(128),
    'c' => SecureRandom.hex(128),
    'd' => SecureRandom.hex(128),
    'e' => SecureRandom.hex(128),
    'f' => SecureRandom.hex(128),
    'g' => SecureRandom.hex(128),
    'h' => SecureRandom.hex(128),
    'i' => SecureRandom.hex(128),
    'j' => SecureRandom.hex(128),
    'k' => SecureRandom.hex(128),
  }
end

data = 10000.times.collect do |i|
  {
    'id' => i + 1,
    'reference' => "coucou:#{i}",
    'hash' => random_hash,
    # 'hash2' => random_hash,
    # 'hash3' => random_hash,
    'valid' => rand < 0.5,
    'total' => rand(100..500),
    'numbers' => [1, 2, 3]
  }
end
puts "data generation OK"

path = 'tmp/test.parquet'
Foo.convert_to(data, path, compression: :gzip)
