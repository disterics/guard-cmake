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
        clean_paths = super
        if @options[:ctest_prefix]
          clean_paths.map! do |path|
            parts = path.split(File::SEPARATOR)
            dir = File.join(@options[:ctest_prefix], parts[1..-1])
            dir if File.directory?(dir)
          end
        end
        clean_paths.compact
      end

    end
  end
end
