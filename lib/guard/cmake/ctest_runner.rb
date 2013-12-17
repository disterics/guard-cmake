module Guard
  class CMake

    require 'guard/cmake/command_runner'

    class CTestRunner < CommandRunner

      require 'guard/cmake/ctest_command'

      def run_all
        _run(true)
      end

      def run(paths)
        _run(false, paths)
      end

      private

      def _run(all, paths = [])
        unless all
          _clean_paths(paths).collect do |path|
            _ctest(path)
          end
        else
          _ctest(nil)
        end
      end

      def _ctest(path)
        command = CTestCommand.new(path)
        _execute(command)
      end

      def _clean_paths(paths)
        dirs = _get_directories(paths)
        if @options[:ctest_prefix]
          dirs.map! do | dir |
            parts = dir.split(File::SEPARATOR)
            test_dir = File.join(@options[:ctest_prefix], parts[1..-1])
            test_dir if _exists_in_build_dir?(test_dir)
          end
        end
        dirs.compact
      end

    end
  end
end
