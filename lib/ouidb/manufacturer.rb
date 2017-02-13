require 'json'

module Ouidb
  class Manufacturer
    def self.[](name)
      @all ||= {}
      @all[name] ||= new(name)
    end

    def self.to_json
      JSON.generate(as_json)
    end

    def self.clear!
      @all.clear if @all
      self
    end

    def self.load_file!(path)
      clear!
      JSON.parse(path.read).each do |name, ranges|
        man = self[name]
        ranges.each { |range| man.ranges << MacRange.new_by_number(range, man) }
      end
      self
    end

    def self.as_json
      Hash[@all.map { |name, man| [name, man.ranges.map(&:as_json)] }]
    end

    attr_reader :ranges, :name

    def initialize(name)
      @name   = name.dup.freeze
      @ranges = Set.new
    end

    def to_s
      name
    end

    def inspect
      "#<Manufacturer ‘#{name}’>"
    end
  end
end
