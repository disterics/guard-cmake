module Guard
  class CMake

    require 'guard/cmake/command_runner'

    class CTestRunner < CommandRunner

      require 'guard/cmake/ctest_command'
      require 'guard/cmake/make_command'

      def run_all
        _run(true)
      end

      def run(paths)
        ::Guard::UI.debug("Run ctest for #{paths}")
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
        result = _build(path)
        _test(path) if result
      end

      def _build(path)
        result = true
        return result if path.nil?
        result = _execute(MakeCommand.new(path.test)) unless _test_path?(path.path)
        result
      end

      def _test(path)
        path = path.nil? ? nil : path.test
        command = CTestCommand.new(path)
        _execute(command)
      end

      def _clean_paths(paths)
        dirs = _get_directories(paths)
        dirs.map! do | dir |
          test_dir = to_test_path(dir)
          OpenStruct.new({:path => dir, :test => test_dir}) if _exists_in_build_dir?(test_dir)
        end
        dirs.compact
      end

      def to_test_path(path)
        dir = path
        if @options[:ctest_prefix]
          parts = dir.split(File::SEPARATOR)
          dir = File.join(@options[:ctest_prefix], parts[1..-1])
        end
        dir
      end

      def _test_path?(path)
        result = false
        if @options[:ctest_prefix]
          result = (path =~ /^#{@options[:ctest_prefix]}/)
        end
        result
      end

    end
  end
end
