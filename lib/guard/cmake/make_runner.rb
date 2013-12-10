module Guard
  class CMake

    require 'guard/cmake/command_runner'
    require 'guard/cmake/make_command'

    class MakeRunner < CommandRunner

      def run_all
        _run(true)
      end

      def run(paths)
        _run(false, paths)
      end

      private

      def _run(all, paths = [])
        unless all
          _clean_paths(paths).reduce(true) do |success, path|
            _make(path) if success
          end
        else
          _make(nil)
        end
      end

      def _make(path)
        command = MakeCommand.new(path)
        _execute(command)
      end

      def _clean_paths(paths)
        clean_paths = paths.collect do | path |
          File.dirname(path)
        end
        clean_paths.uniq
      end

    end
  end
end

