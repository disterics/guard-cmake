require 'guard'
require 'guard/plugin'

module Guard
  class CMake < Plugin


    require 'guard/cmake/runner'

    attr_accessor :runner

    # Initializes a Guard plugin.
    # Don't do any work here, especially as Guard plugins get initialized even if they are not in an active group!
    #
    # @param [Hash] options the custom Guard plugin options
    # @option options [Array<Guard::Watcher>] watchers the Guard plugin file watchers
    # @option options [Symbol] group the group this Guard plugin belongs to
    # @option options [Boolean] any_return allow any object to be returned from a watcher
    #
    def initialize(options = {})
      super
      @options = {
        all_on_start: true,
        project_dir: Dir.pwd
      }.merge(options)
      @runner = Runner.new(@options)
    end

    # Called once when Guard starts. Please override initialize method to init stuff.
    #
    # @raise [:task_has_failed] when start has failed
    # @return [Object] the task result
    #
    def start
      ::Guard::UI.info("Guard::CMake #{Guard::CMakeVersion::VERSION} is running, with cmake!", reset: true)
      run_all if @options[:all_on_start]
    end

    # Called when just `enter` is pressed
    # This method should be principally used for long action like running all specs/tests/...
    #
    # @raise [:task_has_failed] when run_all has failed
    # @return [Object] the task result
    #
    def run_all
      ::Guard::UI.info("Building the whole project")
      _throw_if_failed { runner.run_all }
    end

    # Called when `reload|r|z + enter` is pressed.
     # This method should be mainly used for "reload" (really!) actions like reloading passenger/spork/bundler/...
     #
     # @raise [:task_has_failed] when reload has failed
     # @return [Object] the task result
     #
     def reload
     end

    # Default behaviour on file(s) changes that the Guard plugin watches.
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_change has failed
    # @return [Object] the task result
    #
    def run_on_changes(paths)
      _throw_if_failed { runner.run(paths) }
    end

    private

    def _throw_if_failed
      throw :task_has_failed unless yield
    end

  end
end
