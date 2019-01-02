require 'benchmark/ips'
require 'fast_attributes'
require 'virtus'
require 'attrio'

ATTR_NAMES = [:attr0, :attr1, :attr2, :attr3, :attr4, :attr5, :attr6, :attr7, :attr8, :attr9]

class FastIntegers
  extend  FastAttributes
  define_attributes initialize: true, attributes: true, ignore_undefined: true do
    attribute *ATTR_NAMES, Integer
  end
end

class AttrioIntegers
  include Attrio
  define_attributes do
    ATTR_NAMES.each do |name|
      attr name, Integer
    end
  end

  def initialize(attributes = {})
    attributes.each do |attribute, value|
      public_send("#{attribute}=", value)
    end
  end
end

class VirtusIntegers
  include Virtus.model
  ATTR_NAMES.each do |name|
    attribute name, Integer
  end
end

Benchmark.ips do |x|
  x.config(time: 1, warmup: 1)

  integers    = {attr0: 0, attr1: 1, attr2: 2, attr3: 3, attr4: 4, attr5: 5, attr6: 6, attr7: 7, attr8: 8, attr9: 9}
  strings     = {attr0: '0', attr1: '1', attr2: '2', attr3: '3', attr4: '4', attr5: '5', attr6: '6', attr7: '7', attr8: '8', attr9: '9'}
  undefined   = strings.merge(foo: 'bar')

  x.report('FastAttributes: without values                       ') { FastIntegers.new }
  x.report('FastAttributes: integer values for integer attributes') { FastIntegers.new(integers) }
  x.report('FastAttributes: string values for integer attributes ') { FastIntegers.new(strings) }
  x.report('FastAttributes: undefined attributes                 ') { FastIntegers.new(undefined) }

  x.report('Attrio: without values                               ') { AttrioIntegers.new }
  x.report('Attrio: integer values for integer attributes        ') { AttrioIntegers.new(integers) }
  x.report('Attrio: string values for integer attributes         ') { AttrioIntegers.new(strings) }
  # x.report('Attrio: undefined attributes                         ') { AttrioIntegers.new(undefined) }

  x.report('Virtus: without values                               ') { VirtusIntegers.new }
  x.report('Virtus: integer values for integer attributes        ') { VirtusIntegers.new(integers) }
  x.report('Virtus: string values for integer attributes         ') { VirtusIntegers.new(strings) }
  x.report('Virtus: undefined attributes                         ') { VirtusIntegers.new(undefined) }

  x.compare!
end
