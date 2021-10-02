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

require 'parqueteur'

class FooParquetConverter < Parqueteur::Converter
  column :id, :bigint
  column :reference, :string
  column :amount, :decimal, precision: 12, scale: 4
end

data = [
  { 'id' => 1, 'reference' => 'hello world 1', 'amount' => BigDecimal('789000.5678') },
  { 'id' => 2, 'reference' => 'hello world 2', 'amount' => BigDecimal('789000.5678') },
  { 'id' => 3, 'reference' => 'hello world 3', 'amount' => BigDecimal('789000.5678') }
]

# initialize Converter with Parquet GZIP compression mode
converter = FooParquetConverter.new(data, compression: :gzip)

# write result to file
converter.write('tmp/hello_world.compressed.parquet')
converter.write('tmp/hello_world.parquet', compression: false)

# in-memory result (StringIO)
converter.to_io

# write to temporary file (Tempfile)
# don't forget to `close` / `unlink` it after usage
converter.to_tmpfile

# Arrow Table
table = converter.to_arrow_table
table.each_record do |record|
  pp record.to_h
end
