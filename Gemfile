source 'https://rubygems.org'

gemspec

version = ENV['RAILS_VERSION'] || 'default'

gem 'pg'
gem 'sqlite3', '~> 2.1'

case version
when 'main'
  gem 'railties', git: 'https://github.com/rails/rails.git'
when 'default'
  gem 'railties', '>= 8.0'
else
  gem 'railties', "~> #{version}"
end
