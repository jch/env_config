require 'test_helper'

class ConfigTest < Test::Unit::TestCase
  def test_defaults
    config = EnvConfig::Config.new
    assert_equal "config/application.yml", config.config_path
    assert_equal false, config.override_env
    assert_equal nil, config.namespace_by
    assert_equal '/', config.namespace_delimiter
  end
end