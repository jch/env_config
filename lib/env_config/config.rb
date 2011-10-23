module EnvConfig
  class Config
    # yaml to read default config variables
    # Defaults to config/application.yml
    attr_accessor :config_path

    # Whether to override a variable that's already defined in an environment
    # variable.
    # Defaults to false
    attr_accessor :override_env

    # string to split namespace_by with. defaults to '/'
    attr_accessor :namespace_delimiter

    # Namespace config values
    # Defaults to ""
    # For deeper nesting, separate with '/'.
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
    attr_accessor :namespace_by
    def initialize
      @config_path         = "config/application.yml"
      @override_env        = false
      @namespace_by        = nil
      @namespace_delimiter = "/"
    end
  end
end