module Guard
  class CMake
    class CMakeRunner

      require 'guard/cmake/cmake_command'

      attr_reader :options

      def initialize(opts = {})
        @options = {
        }.merge(opts)
      end

      def run_all
        command = CMakeCommand.new(@options[:build_dir], @options[:project_dir])
        command.run
      end

    end
  end
end
