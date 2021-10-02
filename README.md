# Parqueteur

Parqueteur enables you to generate Apache Parquet files from raw data.

## Dependencies

Since I only tested Parqueteur on Ubuntu, I don't have any install scripts for other operating systems.
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
```ruby
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

# initialize Converter with Parquet GZIP compression mode
converter = FooParquetConverter.new(data, compression: :gzip)

# write result to file
converter.write('hello_world.parquet')

# in-memory result (StringIO)
converter.to_io

# write to temporary file (Tempfile)
# don't forget to `close` / `unlink` it after usage
converter.to_tmpfile
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pocketsizesun/parqueteur-ruby.
