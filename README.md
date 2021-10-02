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

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install parqueteur

## Usage

Parqueteur provides an elegant way to generate Apache Parquet files from a defined schema.
```ruby
class FooParquetConverter < Parqueteur::Converter
  column :id, :bigint
  column :reference, :string
end

data = [
  { 'id' => 1, 'reference' => 'hello world 1' },
  { 'id' => 2, 'reference' => 'hello world 2' },
  { 'id' => 3, 'reference' => 'hello world 3' }
]

FooParquetConverter.convert_to(data, 'hello_world.parquet')
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pocketsizesun/parqueteur-ruby.
