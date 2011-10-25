require "env_config/version"
require "erb"
require "pathname"
require "yaml"
require "env_config/config"
require "env_config/railtie" if defined?(Rails)

module EnvConfig
  extend self

  # EnvConfig::Config object
  attr_accessor :config

  # Creates a new EnvConfig::Config object and yields to block
  # returns config object
  def configure
    @config ||= Config.new
    yield @config if block_given?
    @config
  end
  
  # After #configure, this method sets all scoped variables into environment
  # variables
  def set!(options = {})
    options[:scoped] ||= find_scoped_config
    options[:config] ||= @config
    options[:scoped].each do |key, value|
      ENV[key]   = value if config.override_env
      ENV[key] ||= value
    end
  end

  private

  # iterate through namespaces until we have the scoped config we want
  def find_scoped_config
    # evalute config yaml through erb
    template = Pathname.new(config.config_path).read
    template_result = ERB.new(template).result(binding)
    yaml = YAML::load(template_result)

    return yaml if (config.namespace_by == '' || config.namespace_by.nil?)

    config.namespace_by.split(config.namespace_delimiter).inject(yaml) do |y, scope|
      begin
        y[scope]
      rescue
        # namespace config doesn't match up w/ application yaml
        raise ArgumentError.new("Couldn't find namespace #{scope} within #{config.config_path}")
      end
    end
  end
end

# Initialize default config
EnvConfig.configure