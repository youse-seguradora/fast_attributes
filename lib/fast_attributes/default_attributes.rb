module FastAttributes
  class << self
    def default_attributes(klass)
      @default_attributes[klass] || {}
    end

    def add_default_attribute(klass, attribute, value)
      @default_attributes ||= {}
      @default_attributes[klass] ||= {}
      @default_attributes[klass][attribute] = value.respond_to?(:call) ? value.call : value
    end
  end
end
