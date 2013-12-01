module Guard
  class CMake
    class Runner

      require 'guard/cmake/cmake_runner'

      attr_reader :options

      def initialize(opts = {})
        @options = {
          out_of_src_build: true
        }.merge(opts)
        @cmake = CMakeRunner.new(@options)
      end

      def run_all
        true
      end

    end
  end
end
