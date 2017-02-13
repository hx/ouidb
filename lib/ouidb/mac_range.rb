module Ouidb
  class MacRange
    def self.str_to_int(str)
      raise NotImplementedError if self == MacRange # Must be called on a subclass
      str.gsub(/[^a-f\d]/i, '')[0...(self::SIZE / 4)].to_i(16)
    end

    def self.[](addr)
      if self == MacRange
        Range36[addr] || Range24[addr]
      else
        all[str_to_int(addr)]
      end
    end

    def self.all
      raise NotImplementedError if self == MacRange # Must be called on a subclass
      @all ||= {}
    end

    def self.find_or_create(addr, manufacturer = nil)
      raise NotImplementedError if self == MacRange # Must be called on a subclass
      addr_int = str_to_int(addr)
      all[addr_int] ||= new(addr_int, manufacturer)
    end

    attr_reader :manufacturer

    def initialize(addr, manufacturer)
      raise NotImplementedError if self.class == MacRange # Must be called on a subclass
      @addr = addr
      @manufacturer = manufacturer
    end

    def to_s
      @addr.to_s(16).ljust(12, '0').chars.each_slice(2).map(&:join).join(':') << '/' << self.class::SIZE.to_s << ' ' << manufacturer.to_s
    end

    def as_json
      @addr.to_s(16).ljust(self.class::SIZE / 4, '0')
    end

    class Range24 < MacRange
      SIZE = 24
    end

    class Range36 < MacRange
      SIZE = 36
    end
  end
end
