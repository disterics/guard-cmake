require 'spec_helper'

describe Guard::CMake::Runner, fakefs: true do

  subject { described_class.new }

  let(:cmake_instance) { double(Guard::CMake::MakeRunner) }
  let(:ctest_instance) { double(Guard::CMake::CTestRunner) }
  let(:default_options) { { out_of_src_build: true, build_dir: 'build', project_dir: Dir.pwd } }

  before {
    allow(Kernel).to receive(:system) { true }
    allow(Dir).to receive(:chdir) { true }
    allow(Guard::CMake::CMakeCommand).to receive(:new) { 'cmake' }
    allow(Guard::CMake::CMakeRunner).to receive(:new) { cmake_instance }
    allow(Guard::CMake::CTestRunner).to receive(:new) { ctest_instance }
    allow(cmake_instance).to receive(:run) { true }
    allow(ctest_instance).to receive(:run) { true }
    allow(cmake_instance).to receive(:run_all) { true }
  }

  describe "#initialize" do

    context "with no options" do
      it "sets default options" do
        runner = described_class.new
        expect(runner.instance_variable_get(:@options)[:out_of_src_build]).to be_true
        expect(runner.instance_variable_get(:@options)[:build_dir]).to eq "build"
        expect(runner.instance_variable_get(:@options)[:ctest]).to be_false
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

    context 'with missing build directory' do
      it 'creates build directory' do
        expect(File.directory?(default_options[:build_dir])).to be_false
        described_class.new
        expect(File.directory?(default_options[:build_dir])).to be_true
      end
    end

    describe ":ctest option" do
      context "with :ctest option set to true" do
        it 'instantiates a new CTestRunner' do
          expect(Guard::CMake::CTestRunner).to receive(:new).with(default_options[:project_dir], default_options[:build_dir], {})
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

    describe ":ctest_prefix option" do
      let(:ctest_options) {{ctest_prefix: 'test'}}
      context "with :ctest option set to true" do
        it 'instantiates ctest runner with ctest_prefix' do
          expect(Guard::CMake::CTestRunner).to receive(:new).with(default_options[:project_dir], default_options[:build_dir], ctest_options)
          described_class.new(ctest: true, ctest_prefix: 'test')
        end
      end
    end

  end

  describe "#run_all" do
    let(:cmake) { subject.instance_variable_get(:@cmake) }
    let(:make) { subject.instance_variable_get(:@make) }

    context "with default options" do

      it "generates makefiles in the build directory" do
        expect(cmake).to receive(:run_all)
        subject.run_all
      end

      it "builds the project directory" do
        expect(make).to receive(:run_all).once.and_return(true)
        subject.run_all
      end

    end

    context "with :ctest option set to true" do
      subject { described_class.new(ctest: true) }
      let(:ctest) { subject.instance_variable_get(:@ctest) }

      it 'runs tests in the build directory' do
        expect(ctest).to receive(:run_all).exactly(1).times.and_return(true)
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
