module Guard
  class CMake

    require 'guard/cmake/command_runner'

    class CMakeRunner < CommandRunner

      require 'guard/cmake/cmake_command'

      TITLE = 'CMake results'

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
        Kernel.system(command).tap do | success |
          if success
            ::Guard::Notifier.notify('Success', title: TITLE, image: :success, priority: -2)
          else
            ::Guard::Notifier.notify('Failed', title: TITLE, image: :failed, priority: 2)
          end
        end
      end

    end
  end
end
