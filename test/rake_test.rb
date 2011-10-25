require 'test_helper'
require 'pathname'
require 'fstest'
require 'rake'
load    'tasks/env_config.rake'

class RakeTest < Test::Unit::TestCase
  include FSTest

  def setup
    temp_dir = Pathname.new File.expand_path('../tmp', __FILE__)
    temp_dir.rmtree rescue nil
    temp_dir.mkpath
    @config_path = temp_dir + 'config_dir/config.yml'
    @loader_path = temp_dir + 'app_dir/loader.rb'
    Rake::Task['env_config:init'].reenable  # rake tasks only run once
  end

  def test_init_normal
    capture_io { Rake::Task['env_config:init'].invoke(@config_path, @loader_path, false) }
    assert_file @config_path, /erb_config/
    assert_file @loader_path, /config.namespace_by  = nil/, /EnvConfig.set!/, Regexp.new("config.config_path   = \"#{@config_path}\"")
  end

  def test_init_rails
    capture_io { Rake::Task['env_config:init'].invoke(@config_path, @loader_path, true) }
    assert_file @config_path, /development/
    assert_file @loader_path, /config.namespace_by  = Rails.env/, /EnvConfig.set!/, Regexp.new("config.config_path   = \"#{@config_path}\"")
  end
end