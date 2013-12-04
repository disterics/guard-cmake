module Guard
  class CMake
    class CommandRunner

      def initialize(project_dir, build_dir)
        @project_dir = project_dir
        @build_dir = File.join(project_dir, build_dir)
      end


    end
  end
end
