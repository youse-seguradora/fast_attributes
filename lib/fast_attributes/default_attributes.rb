module FastAttributes
  class << self
    SINGLETON_CLASSES = [::NilClass, ::TrueClass, ::FalseClass, ::Numeric,  ::Symbol].freeze

    def default_attributes(klass)
      return {} unless (@default_attributes || {})[klass]
      @default_attributes[klass].each_with_object({}) do |(attribute, value), memo|
        memo[attribute] = if value.respond_to?(:call)
                            value.call
                          elsif cloneable?(value)
                            value.clone
                          else
                            value
                          end
      end
    end

    def add_default_attribute(klass, attribute, value)
      @default_attributes ||= {}
      @default_attributes[klass] ||= {}
      @default_attributes[klass][attribute] = value
    end

    def cloneable?(value)
      case value
      when *SINGLETON_CLASSES
        false
      else
        true
      end
    end
  end
end
