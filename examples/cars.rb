require 'bundler/setup'
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
converter = CarParquetConverter.new(
  cars, compression: :gzip
)

# write result to file
pp converter.to_arrow_table
