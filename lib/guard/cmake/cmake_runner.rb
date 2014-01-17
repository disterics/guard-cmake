module Guard
  class CMake

    require 'guard/cmake/command_runner'

    class CMakeRunner < CommandRunner

      require 'guard/cmake/cmake_command'

      attr_reader :options

      def run_all
        _run(true)
      end

      def run(paths)
        ::Guard::UI.debug("Run cmake for #{paths}")
        result = true
        result = _run(false) if run_cmake?(paths)
        result
      end

      private

      def run_cmake?(paths)
        cmake_changed?(paths) || !makefile_exists?
      end

      def makefile_exists?
        makefile = File.join(@build_dir, 'Makefile')
        File.file?(makefile)
      end

      def _run(all)
        command = CMakeCommand.new(@project_dir)
        _execute(command)
      end

      def cmake_changed?(paths)
        paths.any? { |path| path =~ /CMakeLists.txt$/}
      end

    end
  end
end
