require 'optparse'
module Rapp
  class CLI
    class << self
      def parse(args)
        options = {:name=>args[0]}

        OptionParser.new do |opts|
          opts.banner = "Usage: rapp new [app_name]"
        end.parse!

        options
      end
    end
  end
end