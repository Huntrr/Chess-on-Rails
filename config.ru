# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)

ActiveRecord::Migrator.migrations_paths = [
  File.expand_path('../db/migrate/', __FILE__)
]
ActiveRecord::Tasks::DatabaseTasks.migrate if ENV['RAILS_ENV'] == 'test'

run Rails.application
