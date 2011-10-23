require 'fileutils'
require 'pathname'
require 'erb'

namespace :env_config do
  desc <<-DOC
    Generate initial config/application.yml config file. config_path defaults
    to 'config/application.yml'.
  DOC
  task :init, :config_path, :loader_path, :rails do |t, args|
    args.with_defaults({
      :rails       => defined?(Rails),
      :config_path => 'config/application.yml',
      :loader_path => defined?(Rails) ?
        'config/initializers/env_config.rb' :
        'env_config.rb'
    })
    
    config_path = Pathname.new(args[:config_path])
    loader_path = Pathname.new(args[:loader_path])
    [config_path, loader_path].each {|path| path.dirname.mkpath}

    # generate template files. too heavy to use thor
    # output to config_path and loader_path
    template_path = Pathname.new File.expand_path('../../../templates', __FILE__)

    # write default config
    unless config_path.exist?
      template = template_path + ((args[:rails] ? "rails." : "")  + "application.yml")
      FileUtils.cp(template, config_path)
    end

    # write default loader
    unless loader_path.exist?
      template = template_path + ((args[:rails] ? "rails." : "")  + "env_config.rb.erb")
      loader_path.open('w') do |f|
        f.write(ERB.new(template.read).result(binding))
      end
    end

    puts "Successfully added config files."
    puts "Take a look at #{config_path} and #{loader_path} for customization"
  end
end