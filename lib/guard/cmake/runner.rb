module Guard
  class CMake
    class Runner

      require 'guard/cmake/cmake_runner'
      require 'guard/cmake/ctest_runner'
      require 'guard/cmake/make_runner'

      attr_reader :options

      def initialize(opts = {})
        @options = {
          out_of_src_build: true,
          build_dir: 'build',
          project_dir: Dir.pwd
        }.merge(opts)
        @cmake = CMakeRunner.new(options[:project_dir], options[:build_dir])
        @make = MakeRunner.new(options[:project_dir], options[:build_dir])
        @ctest = CTestRunner.new(options[:project_dir], options[:build_dir]) if options[:ctest]
      end

      def run_all
        run([@options[:build_dir]])
      end

      def run(paths)
        @cmake.run
        @make.run(paths)
      end

    end
  end
end
