module Guard
  class CMake
    class CommandRunner

      def initialize(project_dir, build_dir)
        @project_dir = project_dir
        @build_dir = File.join(project_dir, build_dir)
      end


      private

      def _in_build_dir
        Dir.chdir(@build_dir) do
          yield
        end
      end

      def _execute(command)
        _in_build_dir { Kernel.system(command) }.tap do | success |
          if success
            ::Guard::Notifier.notify('Success', title: command.title, image: :success, priority: -2)
          else
            ::Guard::Notifier.notify('Failed', title: command.title, image: :failed, priority: 2)
          end
        end
      end
    end
  end
end
