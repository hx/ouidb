module Ouidb
  class MacRange
    class << self
      def str_to_int(str)
        raise NotImplementedError if self == MacRange # Must be called on a subclass
        str.gsub(/[^a-f\d]/i, '')[0...(self::SIZE / 4)].to_i(16)
      end

      def [](addr)
        if self == MacRange
          Range36[addr] || Range24[addr]
        else
          all[str_to_int(addr)]
        end
      end

      def all
        raise NotImplementedError if self == MacRange # Must be called on a subclass
        @all ||= {}
      end

      def find_or_create(addr, manufacturer = nil)
        raise NotImplementedError if self == MacRange # Must be called on a subclass
        addr      = str_to_int(addr)
        all[addr] ||= new(addr, manufacturer)
      end

      def new_by_number(addr, manufacturer)
        klass           = addr < 0 ? Range36 : Range24
        addr            = addr.abs
        klass.all[addr] = klass.new(addr, manufacturer)
      end
    end

    attr_reader :manufacturer

    def initialize(addr, manufacturer)
      raise NotImplementedError if self.class == MacRange # Must be called on a subclass
      @addr         = addr
      @manufacturer = manufacturer
    end

    def to_s
      size = self.class::SIZE
      @addr.to_s(16).rjust(size / 4, '0').ljust(12, '0').chars.each_slice(2).map(&:join).join(':') << '/' << size.to_s << ' ' << manufacturer.to_s
    end

    def as_json
      @addr
    end

    def inspect
      "#<Range#{self.class::SIZE} #{to_s}>"
    end

    class Range24 < MacRange
      SIZE = 24
    end

    class Range36 < MacRange
      SIZE = 36

      def as_json
        -super
      end
    end
  end
end
