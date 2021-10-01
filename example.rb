require 'bundler/setup'
require 'parqueteur'

class Foo < Parqueteur::Converter
  column :id, :long, unsigned: true
  column :reference, :string
  column :hash, :map, key: :string, value: :string
  column :valid, :boolean
  column :numbers, :array, elements: :integer
  column :total, :integer
end

data = [
  { 'id' => 1, 'reference' => 'coucou', 'hash' => { 'a' => 'b' }, 'valid' => true },
  { 'id' => 2, 'reference' => 'coucou', 'hash' => { 'c' => 'd' }, 'valid' => false },
  { 'id' => 3, 'reference' => 'coucou', 'hash' => { 'e' => 'f' }, 'valid' => true }
]

puts Foo.convert(data, output: :io)
