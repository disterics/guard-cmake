module Guard
  class CMake
    class Runner

      require 'guard/cmake/cmake_runner'

      attr_reader :options

      def initialize(opts = {})
        @options = {
          out_of_src_build: true,
          build_dir: 'build'
        }.merge(opts)
        @cmake = CMakeRunner.new(@options)
      end

      def run_all
        run([@options[:build_dir]])
      end

      def run(paths)
        puts "run called"
        true
      end

    end
  end
end
