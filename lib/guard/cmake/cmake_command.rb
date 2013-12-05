require 'guard/cmake/command'

module Guard
  class CMake
    class CMakeCommand < Command

      def initialize(project_dir)
        @project_dir = project_dir
        super(_parts.join(' '))
      end

      private

      def _parts
        parts = ["cmake"]
        parts << @project_dir
      end
    end
  end
end
