require 'test/unit'
require 'env_config'

class Test::Unit::TestCase
  def fixture_path(filename)
    Pathname.new File.expand_path("../fixtures/#{filename}", __FILE__)
  end
end