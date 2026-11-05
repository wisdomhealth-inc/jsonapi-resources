module JSONAPI
  class Error
    attr_accessor :title, :detail, :id, :href, :code, :source, :links, :status, :meta

    # Rack::Utils.status_code takes symbols and integers, and maps symbols that Rack 3.1
    # renamed (e.g. :unprocessable_entity); a direct SYMBOL_TO_STATUS_CODE lookup returned
    # nil for those, which rendered as status 0.
    def self.status_code_string(status)
      status.nil? ? '' : Rack::Utils.status_code(status).to_s
    end

    def initialize(options = {})
      @title          = options[:title]
      @detail         = options[:detail]
      @id             = options[:id]
      @href           = options[:href]
      @code           = if JSONAPI.configuration.use_text_errors
                          TEXT_ERRORS[options[:code]]
                        else
                          options[:code]
                        end
      @source         = options[:source]
      @links          = options[:links]

      @status         = self.class.status_code_string(options[:status])
      @meta           = options[:meta]
    end

    def to_hash
      hash = {}
      instance_variables.each {|var| hash[var.to_s.delete('@')] = instance_variable_get(var) unless instance_variable_get(var).nil? }
      hash
    end

    def update_with_overrides(error_object_overrides)
      @title          = error_object_overrides[:title] || @title
      @detail         = error_object_overrides[:detail] || @detail
      @id             = error_object_overrides[:id] || @id
      @href           = error_object_overrides[:href] || href

      if error_object_overrides[:code]
        # :nocov:
        @code           = if JSONAPI.configuration.use_text_errors
                            TEXT_ERRORS[error_object_overrides[:code]]
                          else
                            error_object_overrides[:code]
                          end
        # :nocov:
      end

      @source         = error_object_overrides[:source] || @source
      @links          = error_object_overrides[:links] || @links

      if error_object_overrides[:status]
        # :nocov:
        @status         = self.class.status_code_string(error_object_overrides[:status])
        # :nocov:
      end
      @meta           = error_object_overrides[:meta] || @meta
    end
  end

  class Warning
    attr_accessor :title, :detail, :code
    def initialize(options = {})
      @title          = options[:title]
      @detail         = options[:detail]
      @code           = if JSONAPI.configuration.use_text_errors
                          TEXT_ERRORS[options[:code]]
                        else
                          options[:code]
                        end
    end

    def to_hash
      hash = {}
      instance_variables.each {|var| hash[var.to_s.delete('@')] = instance_variable_get(var) unless instance_variable_get(var).nil? }
      hash
    end
  end
end
