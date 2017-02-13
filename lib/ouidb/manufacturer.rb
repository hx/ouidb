require 'json'

module Ouidb
  class Manufacturer
    def self.[](name)
      @all ||= {}
      @all[name] ||= new(name)
    end

    def self.dump!
      DB_PATH.open('w') { |f| f.write JSON.generate(as_json) << "\n" }
    end

    def self.as_json
      Hash[@all.map { |name, man| [name, man.ranges.map(&:as_json)] }]
    end

    attr_reader :ranges, :name

    def initialize(name)
      @name   = name.dup.freeze
      @ranges = []
    end

    def to_s
      "#{name} (#{ranges.length} ranges)"
    end
  end
end
