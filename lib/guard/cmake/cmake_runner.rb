module Guard
  class CMake

    require 'guard/cmake/command_runner'

    class CMakeRunner < CommandRunner

      require 'guard/cmake/cmake_command'

      attr_reader :options

      def run_all
        _run(true)
      end

      def run
        unless makefile_exists?
          _run(false)
        end
        true
      end

      private

      def makefile_exists?
        makefile = File.join(@build_dir, 'Makefile')
        File.file?(makefile)
      end

      def _run(all)
        command = CMakeCommand.new(@project_dir)
        _execute(command)
      end

    end
  end
end
