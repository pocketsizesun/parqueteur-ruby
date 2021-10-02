# frozen_string_literal: true

module Parqueteur
  class Input
    include Enumerable

    def self.from(arg)
      return arg if arg.is_a?(self)

      new(arg)
    end

    def initialize(source)
      unless source.is_a?(Enumerable)
        raise ArgumentError, 'Enumerable object expected'
      end

      @source = source
    end

    def each(&block)
      if block_given?
        @source.each(&block)
      else
        @source.to_enum(:each)
      end
    end
  end
end
