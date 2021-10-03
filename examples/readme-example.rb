require 'bundler/setup'
require 'parqueteur'

class FooParquetConverter < Parqueteur::Converter
  column :id, :bigint
  column :reference, :string
  column :datetime, :timestamp
  column :beers_count, :integer

  transform do |item|
    item.merge(
      'datetime' => Time.now
    )
  end

  transform :add_beers

  private

  def add_beers(item)
    item['beers_count'] += rand(1..3)
    item
  end
end

data = 10.times.lazy.map do |i|
  { 'id' => i + 1, 'reference' => 'hello world 1', 'beers_count' => 0 }
end

# initialize Converter with Parquet GZIP compression mode
converter = FooParquetConverter.new(data, compression: :gzip)

# write result to file
converter.write('tmp/hello_world.parquet')

# in-memory result (StringIO)
converter.to_io

# write to temporary file (Tempfile)
# don't forget to `close` / `unlink` it after usage
converter.to_tmpfile

# convert to Arrow::Table
pp converter.to_arrow_table
