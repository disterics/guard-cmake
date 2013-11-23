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
        all_on_start: false
      }.merge(options)
      @runner = Runner.new(@options)
    end

  end
end
