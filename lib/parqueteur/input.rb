# frozen_string_literal: true

module Parqueteur
  class Input
    include Enumerable

    def self.from(arg, options = {})
      new(
        case arg
        when String
          if File.exist?(arg)
            File.new(arg, 'r')
          else
            arg.split("\n")
          end
        when Enumerable
          arg
        end,
        options
      )
    end

    def initialize(source, options = {})
      @source = source
      @options = options
    end

    def each(&block)
      case @source
      when File
        if @options.fetch(:json_newlines, true) == true
          @source.each_line do |line|
            yield(JSON.parse(line.strip))
          end
        else
          JSON.parse(@source.read).each(&block)
        end
        @source.rewind
      when Enumerable
        @source.each(&block)
      end
    end
  end
end
