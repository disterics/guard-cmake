require 'spec_helper'

describe Guard::CMake::Runner do

  describe "#initialize" do

    let(:default_options) { { out_of_src_build: true} }

    context "with no options" do
      it "sets default options" do
        runner = described_class.new
        expect(runner.instance_variable_get(:@options)[:out_of_src_build]).to be_true
      end

      it 'instantiates a new CMakeRunner' do
        expect(Guard::CMake::CMakeRunner).to receive(:new).with(default_options)
        described_class.new
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
