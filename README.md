# EnvConfig

Simple configuration management with environment variables.

Inspired by how Heroku uses environment variables for configs, EnvConfig 
is a no-magic gem for defining configs in yaml, and loading them into
environment variables.

### Features

* application.yml can be templated with erb.
* arbitrary namespaced configuration. e.g. development, qa:mac, integration/aws/ci.
* heroku friendly.
* small library, no additional dependencies

### Installation

Install the gem, and initialize the configuation yaml and configuration loader.

    gem install env_config

    # if using Rails
    rake env_config:init

    # otherwise
    env_config init

### Example

First we define the configs we want in a yaml file:

    # Each key value pair in this file will be read by EnvConfig and set to an
    # environment variable. If an environment variable already exists, then it is
    # not overridden by default. See EnvConfig.configure for more options.

    # shared variables
    common: &common
      env_config1: 'config1_value'
      env_config2: <%= "you can use erb" %>

    # environment specifc variables
    development:
      <<: *common
      env_config1: 'config1_override'

    test:
      <<: *common

    # If your app is deployed on Heroku, then production Heroku values will
    # override these settings because existing variables are not overridden by
    # default. See also: http://devcenter.heroku.com/articles/config-vars
    production:
      <<: *common

Then in config/initializers/env_config.rb

    EnvConfig.configure do |config|
      # yaml to read default config variables
      config.config_path   = 'config/application.yml'

      # Whether to override a variable that's already defined in an environment
      # variable. Keep to false if using Heroku.
      config.override_env  = false

      # Namespace config values
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
      config.namespace_by  = Rails.env

      # Delimiter to split namespaces by when finding scoped config
      config.namespace_delimiter = '/'
    end

    # This actually sets the variables into ENV
    EnvConfig.set!

From here, you can access any of your variables via ENV:

    ENV['my_config_name']

