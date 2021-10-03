# Parqueteur

Parqueteur enables you to generate Apache Parquet files from raw data.

## Dependencies

Since I only tested Parqueteur on Ubuntu, I don't have any install scripts for others operating systems.
### Debian/Ubuntu packages
- `libgirepository1.0-dev`
- `libarrow-dev`
- `libarrow-glib-dev`
- `libparquet-dev`
- `libparquet-glib-dev`

You can check `scripts/apache-arrow-ubuntu-install.sh` script for a quick way to install all of them.
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'parqueteur', '~> 1.0'
```

> (optional) If you don't want to require Parqueteur globally you can add `require: false` to the Gemfile instruction:
```ruby
gem 'parqueteur', '~> 1.0', require: false
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install parqueteur

## Usage

Parqueteur provides an elegant way to generate Apache Parquet files from a defined schema.
Converters accepts any object that implements `Enumerable`.

### Working example

```ruby
require 'parqueteur'

class FooParquetConverter < Parqueteur::Converter
  column :id, :bigint
  column :reference, :string
  column :datetime, :timestamp

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

data = [
  { 'id' => 1, 'reference' => 'hello world 1', 'beers_count' => 0 },
  { 'id' => 2, 'reference' => 'hello world 2', 'beers_count' => 0 },
  { 'id' => 3, 'reference' => 'hello world 3', 'beers_count' => 0 }
]

# initialize Converter with Parquet GZIP compression mode
converter = FooParquetConverter.new(data, compression: :gzip)

# write result to file
converter.write('hello_world.parquet')

# in-memory result (StringIO)
converter.to_io

# write to temporary file (Tempfile)
# don't forget to `close` / `unlink` it after usage
converter.to_tmpfile

# convert to Arrow::Table
pp converter.to_arrow_table
```

### Available Types

| Name (Symbol) | Apache Parquet Type |
| ------------- | --------- |
| `:array` | `Array` |
| `:bigdecimal` | `Decimal256` |
| `:bigint` | `Int64` or `UInt64` with `unsigned: true` option |
| `:boolean` | `Boolean` |
| `:date` | `Date32` |
| `:date32` | `Date32` |
| `:date64` | `Date64` |
| `:decimal` | `Decimal128` |
| `:decimal128` | `Decimal128` |
| `:decimal256` | `Decimal256` |
| `:int32` | `Int32` or `UInt32` with `unsigned: true` option |
| `:int64` | `Int64` or `UInt64` with `unsigned: true` option |
| `:integer` | `Int32` or `UInt32` with `unsigned: true` option |
| `:map` | `Map` |
| `:string` | `String` |
| `:struct` | `Struct` |
| `:time` | `Time32` |
| `:time32` | `Time32` |
| `:time64` | `Time64` |
| `:timestamp` | `Timestamp` |

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pocketsizesun/parqueteur-ruby.
