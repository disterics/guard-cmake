require 'guard/cmake/command'

module Guard
  class CMake
    class CMakeCommand < Command

      def initialize(build_dir, project_dir)
        @build_dir = build_dir
        @project_dir = project_dir
      end

    end
  end
end
