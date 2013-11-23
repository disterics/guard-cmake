require 'spec_helper'

describe Guard::CMake do

  subject { described_class.new }
  let(:runner) { subject.instance_variable_get(:@runner) }
  let(:default_options) { { all_on_start: false } }

  describe '#initialize' do
    it 'instantiates a new Runner' do
      expect(Guard::CMake::Runner).to receive(:new)
      described_class.new
    end

    context "with options given " do
      it 'instantiates Runner with options' do
        expect(Guard::CMake::Runner).to receive(:new).with(default_options.merge(foo: :bar))
        described_class.new(foo: :bar)
      end
    end
  end
end
