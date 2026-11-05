module JSONAPI
  module Resources
    class Railtie < Rails::Railtie
      initializer 'jsonapi_resources.deprecator' do |app|
        app.deprecators[:jsonapi_resources] = JSONAPI.deprecator
      end

      rake_tasks do
        load 'tasks/check_upgrade.rake'
      end
    end
  end
end