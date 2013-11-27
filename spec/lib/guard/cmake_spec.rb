require 'spec_helper'

describe Guard::CMake do

  subject { described_class.new }
  let(:runner) { subject.instance_variable_get(:@runner) }
  let(:default_options) { { all_on_start: true } }

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


  describe "#start" do
    context ":all_on_start option not specified" do
      it "displays a start message" do
        expect(::Guard::UI).to receive(:info).with("Guard::CMake #{Guard::CMakeVersion::VERSION} is running, with cmake!", reset: true)
        subject.stub(:run_all)
        subject.start
      end

      it "calls #run_all by default" do
        expect(subject).to receive(:run_all)
        subject.start
      end
    end

  end

end
