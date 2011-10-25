module EnvConfig
  class Railtie < Rails::Railtie
    railtie_name :env_config
    rake_tasks do
      load "tasks/env_config.rake"
    end
  end
end