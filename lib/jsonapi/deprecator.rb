module JSONAPI
  # The gem's own deprecator. Rails 7.2 made the global ActiveSupport::Deprecation
  # singleton private, so libraries warn through their own instance. The railtie
  # registers it with the host app, which applies the app's deprecation behavior to it.
  def self.deprecator
    @deprecator ||= ActiveSupport::Deprecation.new('0.11', 'JSONAPI::Resources')
  end
end
