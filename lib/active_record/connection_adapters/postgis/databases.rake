# frozen_string_literal: true

namespace :db do
  namespace :gis do
    desc "Setup PostGIS data in the database"
    task setup: [:load_config] do
      environments = [Rails.env]
      environments << "test" if Rails.env.development?
      environments.each do |environment|
        ActiveRecord::Base.configurations
          .configs_for(env_name: environment)
          .reject do |env|
            db_config = ActiveRecord::Base.configurations.configs_for(env_name: env)
            db_config.configuration_hash["database"].empty?
          end.each do |env|
            db_config = ActiveRecord::Base.configurations.configs_for(env_name: env)
            ActiveRecord::ConnectionAdapters::PostGIS::PostGISDatabaseTasks.new(db_config).setup_gis
          end
      end
    end
  end
end
