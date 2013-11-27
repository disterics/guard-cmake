module Guard
  class CMake
    class Runner

      attr_reader :options

      def initialize(opts = {})
        @options = {
        }.merge(opts)
      end

    end
  end
end
