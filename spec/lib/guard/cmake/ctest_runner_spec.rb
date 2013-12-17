require 'spec_helper'

describe Guard::CMake::CTestRunner do

  subject { described_class.new(project_dir, build_dir) }

  let(:build_dir) { 'build' }
  let(:command) { double('command', :title => 'command' ) }
  let(:full_build_path) { File.join(project_dir, build_dir) }
  let(:project_dir) { 'tmp/project1' }


  before {
    allow(Kernel).to receive(:system) { true }
    allow(Guard::CMake::CTestCommand).to receive(:new) { command }
    allow(Guard::Notifier).to receive(:notify) { true }
    allow(Dir).to receive(:chdir) { true }
  }

  describe "#initialize" do
    it "instantiates with options" do
      expect(described_class).to receive(:new).with(project_dir, build_dir)
      described_class.new(project_dir, build_dir)
    end
  end

  describe "#run_all" do

    it "builds command with no directory" do
      expect(Guard::CMake::CTestCommand).to receive(:new).with(nil).exactly(1).times.and_return(command)
      subject.run_all
    end

    it "runs command in build directory" do
      expect(Dir).to receive(:chdir).with(full_build_path)
      subject.run_all
    end

  end

  describe "#run" do
    let(:paths) { %w[src/path1/a.cpp src/path2/b.h] }

    it "builds command with each directory" do
      expect(Guard::CMake::CTestCommand).to receive(:new).with(File.dirname(paths[0])).ordered.and_return(command)
      expect(Guard::CMake::CTestCommand).to receive(:new).with(File.dirname(paths[1])).ordered.and_return(command)
      subject.run(paths)
    end

    it "runs command in build directory" do
      expect(Dir).to receive(:chdir).with(full_build_path)
      subject.run(paths)
    end

    context "with :ctest_prefix option", fakefs: true do

      subject { described_class.new(project_dir, build_dir, options) }

      let(:options) {{ctest_prefix: 'test'}}
      let (:test_paths) { %w[test/path1 test/path2] }

      before {
        FileUtils.makedirs(test_paths)
        allow(Dir).to receive(:chdir) { true }
      }

      it "creates command with each directory prefixed with :ctest_prefix one level deep" do
        expect(Guard::CMake::CTestCommand).to receive(:new).with(test_paths[0]).ordered.and_return(command)
        expect(Guard::CMake::CTestCommand).to receive(:new).with(test_paths[1]).ordered.and_return(command)
        subject.run(paths)
      end

      context "with missing target folder" do
        let(:paths) { %w[src/path3/a.cpp src/path4/b.h] }

        it "does not create commands for missing target directories" do
          expect(Guard::CMake::CTestCommand).to_not receive(:new)
          subject.run(paths)
        end
      end

    end

  end

end
