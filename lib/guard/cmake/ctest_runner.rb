module Guard
  class CMake

    require 'guard/cmake/command_runner'

    class CTestRunner < CommandRunner

      def run(paths)
        paths
      end

    end
  end
end
