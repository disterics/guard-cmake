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
        _setup
        @cmake = CMakeRunner.new(options[:project_dir], options[:build_dir])
        @make = MakeRunner.new(options[:project_dir], options[:build_dir])
        @ctest = CTestRunner.new(options[:project_dir], options[:build_dir]) if options[:ctest]
      end

      def run_all
        result = @cmake.run
        result = @make.run_all if result
        result = @ctest.run_all if result && @ctest
      end

      def run(paths)
        result = @cmake.run
        result = @make.run(paths) if result
        result = @ctest.run(paths) if result && @ctest
        result
      end

      private

      def _setup
        unless File.directory?(@options[:build_dir])
          FileUtils.mkpath(@options[:build_dir])
        end
      end
    end
  end
end
