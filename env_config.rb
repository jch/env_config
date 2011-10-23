EnvConfig.configure do |config|
  # yaml to read default config variables
  config.config_path   = /Users/jch/projects/beerpad/env_config/test/tmp/config_dir/loader.yml

  # Whether to override a variable that's already defined in an environment
  # variable. Keep to false if using Heroku.
  config.override_env  = false

  # Namespace config values
  # for deeper nesting, separate with '/'.
  # For example, to namespace by platform and rails environment
  # 
  #   config.namespace_by = "{RbConfig::CONFIG['host_os']}/#{Rails.env}"
  #
  # Then in your config/application.yml, you can nest your config by the
  # namepaces.
  # 
  #   darwin11.0.0:
  #     development:
  #       var_name: "mac development specific value"
  # 
  config.namespace_by  = ""
end