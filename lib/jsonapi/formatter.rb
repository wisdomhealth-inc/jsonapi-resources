module JSONAPI
  class Formatter
    class << self
      def format(arg)
        arg.to_s
      end

      def unformat(arg)
        arg
      end

      if RUBY_VERSION >= '2.0'
        def formatter_for(format)
          formatter_class_name = "#{format.to_s.camelize}Formatter"
          Object.const_get formatter_class_name if formatter_class_name
        end
      else
        def formatter_for(format)
          formatter_class_name = "#{format.to_s.camelize}Formatter"
          formatter_class_name.safe_constantize if formatter_class_name
        end
      end
    end
  end

  class KeyFormatter < Formatter
    class << self
      def format(key)
        super
      end

      def unformat(formatted_key)
        super.to_sym
      end
    end
  end

  class ValueFormatter < Formatter
    class << self
      def format(raw_value, source, context)
        super(raw_value)
      end

      def unformat(value, resource_klass, context)
        super(value)
      end

      def value_formatter_for(type)
        formatter_name = "#{type.to_s.camelize}Value"
        formatter_for(formatter_name)
      end
    end
  end
end

class UnderscoredKeyFormatter < JSONAPI::KeyFormatter
end

class CamelizedKeyFormatter < JSONAPI::KeyFormatter
  class << self
    def format(key)
      super.camelize(:lower)
    end

    def unformat(formatted_key)
      formatted_key.to_s.underscore.to_sym
    end
  end
end

class DasherizedKeyFormatter < JSONAPI::KeyFormatter
  class << self
    def format(key)
      super.dasherize
    end

    def unformat(formatted_key)
      formatted_key.to_s.underscore.to_sym
    end
  end
end

class DefaultValueFormatter < JSONAPI::ValueFormatter
  class << self
    def format(raw_value, source, context)
      case raw_value
        when String, Integer
          return raw_value
        else
          return raw_value.to_s
      end
    end
  end
end