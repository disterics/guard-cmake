require 'spec_helper'

describe Guard::CMake::Runner, fakefs: true do

  subject { described_class.new }
  let(:default_options) { { out_of_src_build: true, build_dir: 'build', project_dir: Dir.pwd } }
  let(:cmake_instance) { double(Guard::CMake::MakeRunner) }

  before {
    allow(Kernel).to receive(:system) { true }
    allow(Dir).to receive(:chdir) { true }
    allow(Guard::CMake::CMakeCommand).to receive(:new) { 'cmake' }
    allow(Guard::CMake::CMakeRunner).to receive(:new) { cmake_instance }
    allow(cmake_instance).to receive(:run) { true }
  }

  describe "#initialize" do

    context "with no options" do
      it "sets default options" do
        runner = described_class.new
        expect(runner.instance_variable_get(:@options)[:out_of_src_build]).to be_true
        expect(runner.instance_variable_get(:@options)[:build_dir]).to eq "build"
      end

      it 'instantiates a new CMakeRunner' do
        expect(Guard::CMake::CMakeRunner).to receive(:new).with(default_options[:project_dir], default_options[:build_dir])
        described_class.new
      end

      it 'instantiates a new MakeRunner' do
        expect(Guard::CMake::MakeRunner).to receive(:new).with(default_options[:project_dir], default_options[:build_dir])
        described_class.new
      end

      it 'does not instantiate a new CTestRunner' do
        expect(Guard::CMake::CTestRunner).to_not receive(:new)
        described_class.new
      end
    end

    describe ":ctest option" do
      context "with :ctest option set to true" do
        it 'instantiates a new CTestRunner' do
          expect(Guard::CMake::CTestRunner).to receive(:new).with(default_options[:project_dir], default_options[:build_dir])
          described_class.new(ctest: true)
        end
      end

      context "with :ctest option set to false" do
        it 'does not instantiate a new CTestRunner' do
          expect(Guard::CMake::CTestRunner).to_not receive(:new)
          described_class.new(ctest: false)
        end
      end
    end

    context 'with missing build directory' do
      it 'creates build directory' do
        expect(File.directory?(default_options[:build_dir])).to be_false
        described_class.new
        expect(File.directory?(default_options[:build_dir])).to be_true
      end
    end
  end

  describe "#run_all" do

    context "with default options" do
      it "builds the project directory" do
        expect(subject).to receive(:run).with(["build"])
        subject.run_all
      end
    end

  end

  describe "#run" do
    let(:cmake) { subject.instance_variable_get(:@cmake) }
    let(:make) { subject.instance_variable_get(:@make) }

    it "generates makefiles in the given directories" do
      expect(cmake).to receive(:run).once.and_return(true)
      subject.run(["build"])
    end

    it "builds the given directories" do
      expect(make).to receive(:run).with(["build"]).exactly(1).times.and_return(true)
      subject.run(["build"])
    end

    context "with :ctest option set to true" do
      subject { described_class.new(ctest: true) }
      let(:ctest) { subject.instance_variable_get(:@ctest) }
      it 'runs tests in the given directories' do
        expect(ctest).to receive(:run).with(["build"]).exactly(1).times.and_return(true)
        subject.run(["build"])
      end
    end

  end

end
