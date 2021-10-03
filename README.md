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

Converters accepts any object that implements `Enumerable` as data source.

### Working example

```ruby
require 'parqueteur'

class FooParquetConverter < Parqueteur::Converter
  column :id, :bigint
  column :reference, :string
  column :datetime, :timestamp
end

data = [
  { 'id' => 1, 'reference' => 'hello world 1', 'datetime' => Time.now },
  { 'id' => 2, 'reference' => 'hello world 2', 'datetime' => Time.now },
  { 'id' => 3, 'reference' => 'hello world 3', 'datetime' => Time.now }
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

### Using transformers

You can use transformers to apply data items transformations.

From `examples/cars.rb`:

```ruby
require 'parqueteur'

class Car
  attr_reader :name, :production_year

  def initialize(name, production_year)
    @name = name
    @production_year = production_year
  end
end

class CarParquetConverter < Parqueteur::Converter
  column :name, :string
  column :production_year, :integer

  transform do |car|
    {
      'name' => car.name,
      'production_year' => car.production_year
    }
  end
end

cars = [
  Car.new('Alfa Romeo 75', 1985),
  Car.new('Alfa Romeo 33', 1983),
  Car.new('Audi A3', 1996),
  Car.new('Audi A4', 1994),
  Car.new('BMW 503', 1956),
  Car.new('BMW X5', 1999)
]

# initialize Converter with Parquet GZIP compression mode
converter = CarParquetConverter.new(data, compression: :gzip)

# write result to file
pp converter.to_arrow_table
```

Output:
```
#<Arrow::Table:0x7fc1fb24b958 ptr=0x7fc1faedd910>
#     name           production_year
0     Alfa Romeo 75  1985
1     Alfa Romeo 33  1983
2     Audi A3        1996
3     Audi A4        1994
4     BMW 503        1956
5     BMW X5         1999
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
