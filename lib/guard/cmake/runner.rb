module Guard
  class CMake
    class Runner

      require 'guard/cmake/cmake_runner'
      require 'guard/cmake/ctest_runner'
      require 'guard/cmake/make_runner'

      DEFAULT_OPTS = {
        build_dir: 'build',
        ctest: false,
        out_of_src_build: true,
        project_dir: Dir.pwd
      }

      attr_reader :options

      def initialize(opts = {})
        extra_opts = _setup({project_dir: Dir.pwd}.merge(opts))
        @cmake = CMakeRunner.new(options[:project_dir], options[:build_dir])
        @make = MakeRunner.new(options[:project_dir], options[:build_dir])
        @ctest = CTestRunner.new(options[:project_dir], options[:build_dir], extra_opts) if options[:ctest]
      end

      def run_all
        result = @cmake.run_all
        result = @make.run_all if result
        result = @ctest.run_all if result && @ctest
      end

      def run(paths)
        result = @cmake.run(paths)
        result = @make.run(paths) if result
        result = @ctest.run(paths) if result && @ctest
        result
      end

      private

      def _setup(opts)

        @options = DEFAULT_OPTS.merge(opts)

        keys = DEFAULT_OPTS.keys
        unused = opts.reject do | k |
          keys.include?(k)
        end

        unless File.directory?(@options[:build_dir])
          FileUtils.mkpath(@options[:build_dir])
        end
        unused
      end
    end
  end
end
