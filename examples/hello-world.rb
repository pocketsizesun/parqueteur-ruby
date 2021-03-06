require 'securerandom'
require 'bundler/setup'
require 'parqueteur'

class FooParquetConverter < Parqueteur::Converter
  column :id, :bigint
  column :my_string_array, :array, elements: :string
  column :my_date, :date
  column :my_decimal, :decimal, precision: 12, scale: 4
  column :my_int, :integer
  column :my_map, :map, key: :string, value: :string
  column :my_string, :string
  column :my_struct, :struct do
    field :my_struct_str, :string
    field :my_struct_int, :integer
  end
  column :my_time, :time
  column :my_timestamp, :timestamp
end

data = 1000.times.collect do |i|
  {
    'id' => i,
    'my_string_array' => %w[a b c],
    'my_date' => Date.today,
    'my_decimal' => BigDecimal('0.03'),
    'my_int' => rand(1..10),
    'my_map' => 20.times.each_with_object({}) do |idx, hash|
      hash["k_#{idx}"] = SecureRandom.urlsafe_base64(64)
    end,
    'my_string' => 'Hello World',
    'my_struct' => {
      'my_struct_str' => 'Hello World',
      'my_struct_int' => 1
    },
    'my_time' => 3600,
    'my_timestamp' => Time.now
  }
end

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
  # pp record['my_decimal'].to_f
  pp record.to_h
end
