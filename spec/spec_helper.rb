require 'rspec'
require 'guard/cmake'

RSpec.configure do |config|
  config.color_enabled = true
  config.order = :random
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
