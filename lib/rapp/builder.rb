require 'fileutils'
require 'erb'
require 'ostruct'

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
    "spec"
  ]
  class Builder
    class << self
      def new_app(opts={})
        # Get name
        raise ArgumentError.new("You must provide a name") unless app_name = opts.delete("name")
        # Check if folder exists
        root_dir = "#{`pwd`.strip}/#{app_name}"
        raise ArgumentError.new("Directory #{root_dir} already exists") if File.directory?(root_dir) 
        # Check if it's empty
        raise ArgumentError.new("Directory #{root_dir} not empty") unless Dir["#{root_dir}/*"].empty? 
        
        # Build the directory structure first
        Dir.mkdir(root_dir)

        DirectoryStructure.each do |dir|
          dir_name = "#{root_dir}/#{dir}"
          FileUtils.mkdir_p(dir_name) unless File.directory?(dir_name)
        end
        
        # For each template, render it, place it in the folder structure it corresponds to
        template_root = File.join(File.dirname(__FILE__), 'templates')
        
        # Construct the data object
        template_binding = OpenStruct.new({:name=>app_name, :class_name=>classify(app_name)})
        Dir["#{template_root}/**/*"].reject { |p| File.directory? p }.each do |template|
          template_data = File.read(template)
          relative_name = template.split("templates/")[1][0..-5]
          # Hack to make the entry point ruby file share the same name as the app
          relative_name = "#{app_name}.rb" if relative_name == "app.rb"
          result = ERB.new(template_data).result(template_binding.instance_eval {binding})
          File.write("#{root_dir}/#{relative_name}", result)
        end

        puts "Finished creating #{app_name}"
        puts "#{`find ./#{app_name}`}"
      end

      def classify(string)
        string.gsub(/(?<=_|^)(\w)/){$1.upcase}.gsub(/(?:_)(\w)/,'\1')
      end
    end
  end
end