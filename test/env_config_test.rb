require 'test_helper'

class EnvConfigTest < Test::Unit::TestCase
  def setup
    EnvConfig.config = nil
    @config = EnvConfig.configure
    ENV.delete_if { true }
  end

  def test_default_configure
    assert_not_nil @config
  end

  def test_configure_yields_same_config
    EnvConfig.configure do |new_config|
      assert_equal @config, new_config
    end
  end

  def test_flat_app_config
    EnvConfig.configure do |c|
      c.config_path         = fixture_path('flat.yml')
      c.namespace_by        = ''
    end
    scoped = EnvConfig.send(:find_scoped_config)
    assert_equal 2, scoped.keys.size
    assert_equal 'NYC', scoped['city']
    assert_equal 'NY', scoped['state']
  end

  def test_scoped_app_config
    EnvConfig.configure do |c|
      c.config_path         = fixture_path('nested.yml')
      c.namespace_by        = 'foo:bar'
      c.namespace_delimiter = ':'
    end
    scoped = EnvConfig.send(:find_scoped_config)
    assert_equal 2, scoped.keys.size
    assert_equal 'Sam Adams', scoped['beer']
    assert_equal 'PopEyes', scoped['dinner']
  end

  def test_invalid_scope
    EnvConfig.configure do |c|
      c.config_path         = fixture_path('flat.yml')
      c.namespace_by        = 'foo:bar'
      c.namespace_delimiter = ':'
    end
    assert_raises(ArgumentError) do
      EnvConfig.send(:find_scoped_config)
    end
  end

  def test_set_environment_no_override
    ENV['city'] = "Austin"
    EnvConfig.configure do |c|
      c.config_path         = fixture_path('flat.yml')
      c.override_env        = false
    end
    EnvConfig.set!
    assert_equal 'Austin', ENV['city']
  end

  def test_set_environment_override
    ENV['city'] = "Berkeley"
    EnvConfig.configure do |c|
      c.config_path         = fixture_path('flat.yml')
      c.override_env        = true
    end
    EnvConfig.set!
    assert_equal 'NYC', ENV['city']
  end
end