require 'guard/cmake/command'

module Guard
  class CMake
    class MakeCommand < Command

      TITLE = 'Make results'

      def initialize(path)
        @path = path
        super(TITLE, _parts.join(' '))
      end

      private

      def _parts
        parts = ["make"]
        parts << "-C #{@path}" if @path
        parts
      end
    end
  end
end
