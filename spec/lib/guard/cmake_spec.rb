require 'spec_helper'

describe Guard::CMake do

  subject { described_class.new }
  let(:runner) { subject.instance_variable_get(:@runner) }
  let(:default_options) { { all_on_start: true, project_dir: Dir.pwd } }

  describe '#initialize' do
    it 'instantiates a new Runner' do
      expect(Guard::CMake::Runner).to receive(:new)
      described_class.new
    end

    context "with options given" do
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

    context ":all_on_start option is false" do
      subject { described_class.new(all_on_start: false) }

      it "doesn't call #run_all" do
        expect(subject).to_not receive(:run_all)
        subject.start
      end
    end
  end

  describe '#run_all' do
    it "prints building project message" do
      runner.stub(:run_all) { true }
      expect(Guard::UI).to receive(:info).with("Building the whole project")
      subject.run_all
    end

    it "builds the whole project" do
      expect(runner).to receive(:run_all)
      runner.stub(:run_all) { true }
      subject.run_all
    end
  end

  describe '#reload' do
    it 'runs cmake' do
      expect(runner).to receive(:reload).and_return(true)
      subject.reload
    end
  end

  describe '#run_on_changes' do
    it 'runs make in directories with changes' do
      expect(runner).to receive(:run).with(['src/a']).and_return(true)
      subject.run_on_changes(['src/a/a.cpp', 'src/a/a.h'])
    end
  end

end
