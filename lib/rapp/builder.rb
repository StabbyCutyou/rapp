require 'fileutils'
require 'erb'
require 'ostruct'
require 'rapp/version'

module Rapp
  DirectoryStructure = [
    "app",
    "app/models",
    "app/services",
    "app/jobs",
    "bin",
    "config",
    "config/environments",
    "config/initializers",
    "lib",
    "lib/tasks",
  ]

  SpecStructure = [
    "spec",
    "spec/app_name_base"
  ]
  class Builder
    class << self
      def new_app(opts={})
        # Get name
        raise ArgumentError.new("You must provide a name") unless app_name = opts[:name]
        # Check if folder exists
        root_dir = "#{`pwd`.strip}/#{app_name}"
        raise ArgumentError.new("Directory #{root_dir} already exists") if File.directory?(root_dir) 
        
        # Build the directory structure first
        Dir.mkdir(root_dir)

        DirectoryStructure.each do |dir|
          dir_name = "#{root_dir}/#{dir}"
          FileUtils.mkdir_p(dir_name) unless File.directory?(dir_name)
        end
        
        # For each template, render it, place it in the folder structure it corresponds to
        
        # Construct the data object
        template_binding = OpenStruct.new(
          { :name=>app_name, 
            :class_name=>classify(app_name),
            :rapp_version=>Rapp::VERSION
          })

        # Skip spec dirs unless they said they wanted it
        # My intention here is to use "or" specifically, because it does not short-circuit. The second check is very important
        Dir["#{template_root}/**/*"].reject { |p|  File.directory? p or p.include?('spec') }.each do |template|
          template_data = File.read(template)
          relative_name = template.split("templates/")[1][0..-5]
          # Hack to make the entry point ruby file share the same name as the app
          # Need to clean this up, make it more extensible...
          relative_name = "#{app_name}.rb" if relative_name == "app.rb"
          relative_name = "#{app_name}_base.rb" if relative_name == "app_base.rb"
          
          result = ERB.new(template_data).result(template_binding.instance_eval {binding})
          File.write("#{root_dir}/#{relative_name}", result)
        end

        # If set on the cli, build the spec stuff
        add_specs(root_dir, opts) if opts[:specs]

        puts "Finished creating #{app_name}"
        puts "#{`find ./#{app_name}`}"
      end

      def add_specs(root_dir, options)
        app_name = options[:name]
        #add rspec to the gemfile
        open("#{root_dir}/Gemfile", 'a') do |f|
          f.puts 'gem "rspec", "~>3.1.0"'
        end

        # Create the directory structrue
        SpecStructure.each do |dir|
          name = dir.gsub!('app_name', app_name) if dir.include?("app_name")
          dir_name = "#{root_dir}/#{name}"
          FileUtils.mkdir_p(dir_name) unless File.directory?(dir_name)
        end

        # Construct the data object
        template_binding = OpenStruct.new(
          { :name=>app_name, 
            :class_name=>classify(app_name),
            :rapp_version=>Rapp::VERSION
          })

        # Get all the spec templates
        Dir["#{template_root}/spec/**/*"].reject {|p| File.directory? p }.each do |template|
          template_data = File.read(template)
          relative_name = template.split("templates/")[1][0..-5]
          relative_name = relative_name.gsub!('app_name', app_name) if relative_name.include?("app_name")
          result = ERB.new(template_data).result(template_binding.instance_eval {binding})
          File.write("#{root_dir}/#{relative_name}", result)
        end
      end

      def classify(string)
        string.gsub(/(?<=_|^)(\w)/){$1.upcase}.gsub(/(?:_)(\w)/,'\1')
      end

      def template_root
        File.join(File.dirname(__FILE__), 'templates')
      end 
    end
  end
end