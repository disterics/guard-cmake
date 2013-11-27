require 'spec_helper'

describe Guard::CMake::Runner do

  describe "#initialize" do

    describe "sets the @runner instance variable from options" do
      it "sets default options" do
        runner = described_class.new
        expect(runner.instance_variable_get(:@options)[:all_on_start]).to be_false
      end
    end

    describe ":cmd option" do
      context "with custom cmd" do
        let(:options) { { run_all: { cmd: 'make -j 2' } } }
        it "builds command with custom options" do
#          expect(Guard::RSpec::Command).to receive(:new).with(kind_of(Array), hash_including(cmd: 'rspec -t ~slow'))
#        runner.run_all
      end
    end
    end
  end
end
