module Ouidb
  class Importer
    def self.read(io)
      new(io).read
    end

    def initialize(io)
      @io = io
    end

    def read
      block = []
      while (line = @io.gets)
        block << line
        if line.strip == ''
          read_block block
          block.clear
        end
      end
    end

    FIRST_LINE  = /\A (?<hex>([a-f\d]{2})(-([a-f\d]{2})){2}) \s+ \(hex\) \s+ (?<name>.+?)\s*\n\z/ix
    SECOND_LINE = /\A (?<start>[a-f\d]{6})(-(?<end>[a-f\d]{6}))? \s/ix

    def read_block(lines)
      return unless (match = FIRST_LINE.match(lines.shift))
      hex  = match[:hex].delete('-')
      name = match[:name].gsub(/\s+/, ' ')

      return unless (match = SECOND_LINE.match(lines.shift))
      hex << match[:start][0...3] if match[:end]

      # TODO addresses

      manufacturer = Manufacturer[name]
      manufacturer.ranges << (match[:end] ? MacRange::Range36 : MacRange::Range24).find_or_create(hex, manufacturer)
    end
  end
end
