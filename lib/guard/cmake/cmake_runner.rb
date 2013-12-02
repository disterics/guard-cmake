module Guard
  class CMake
    class CMakeRunner

      require 'guard/cmake/cmake_command'

      attr_reader :options

      def initialize(opts = {})
        @options = {
        }.merge(opts)
        @project_dir = opts[:project_dir]
        @build_dir = File.join(opts[:project_dir], opts[:build_dir])
      end

      def run_all
        command = CMakeCommand.new(@options[:build_dir], @options[:project_dir])
        command.run
      end

      def run
        unless makefile_exists?
          command = CMakeCommand.new(@options[:build_dir], @options[:project_dir])
          command.run
        end
      end

      private

      def makefile_exists?
        makefile = File.join(@build_dir, 'Makefile')
        File.file?(makefile)
      end
    end
  end
end
