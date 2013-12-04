module Guard
  class CMake

    require 'guard/cmake/command_runner'

    class CMakeRunner < CommandRunner

      require 'guard/cmake/cmake_command'

      attr_reader :options

      def run_all
        command = CMakeCommand.new(@build_dir, @project_dir)
        command.run
      end

      def run
        unless makefile_exists?
          command = CMakeCommand.new(@build_dir, @project_dir)
          command.run
        end
        true
      end

      private

      def makefile_exists?
        makefile = File.join(@build_dir, 'Makefile')
        File.file?(makefile)
      end
    end
  end
end
