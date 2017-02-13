require 'ouidb/version'
require 'ouidb/mac_range'
require 'ouidb/manufacturer'

require 'pathname'

module Ouidb
  class << self
    def lookup(address)
      MacRange[address.to_s]
    end

    def manufacturer_name(address)
      range = MacRange[address]
      range && range.manufacturer.name
    end

    def load_file(path)
      Manufacturer.load_file! Pathname(path)
      self
    end
  end
end
