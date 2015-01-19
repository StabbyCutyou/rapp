require 'optparse'
module Rapp
  class CLI
    class << self
      def parse(args)
        options = {:name=>args[0]}

        OptionParser.new do |opts|
          opts.banner = "Usage: rapp [app_name]"

          opts.on("-s", "--specs", "Generate basic validation specs for the app you build") do
            options[:specs] = true
          end
        end.parse!

        options
      end
    end
  end
end