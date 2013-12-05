require 'spec_helper'

describe Guard::CMake::CMakeRunner do

  subject { described_class.new(project_dir, build_dir) }

  let(:project_dir) { '/tmp/project1' }
  let(:build_dir) { 'build' }
  let(:command) { double('command', :run => true) }

  before {
    allow(Kernel).to receive(:system) { true }
    allow(Guard::CMake::CMakeCommand).to receive(:new) { 'cmake' }
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
    context "with no existing makefile" do
      it "builds command with project dir" do
        expect(Guard::CMake::CMakeCommand).to receive(:new).with(project_dir).exactly(1).times.and_return(command)
        subject.run_all
      end
    end

    context "with existing makefile", fakefs: true do
      before {
        FileUtils.mkdir_p(File.join(project_dir, build_dir))
        FileUtils.touch(File.join(project_dir, build_dir, 'Makefile'))
      }

      it "builds command with project dir" do
        expect(Guard::CMake::CMakeCommand).to receive(:new).with(project_dir).exactly(1).times.and_return(command)
        subject.run_all
      end
    end
  end

  describe "#run" do
    context "with no existing makefile" do
      it "builds command with project dir" do
        expect(Guard::CMake::CMakeCommand).to receive(:new).with(project_dir).exactly(1).times.and_return(command)
        subject.run
      end
    end

    context "with existing makefile", fakefs: true do
      before {
        FileUtils.mkdir_p(File.join(project_dir, build_dir))
        FileUtils.touch(File.join(project_dir, build_dir, 'Makefile'))
      }

      it "does not build command" do
        expect(Guard::CMake::CMakeCommand).to_not receive(:new)
        subject.run
      end
    end

    it "runs command in build directory" do
      expect(Dir).to receive(:chdir).with(File.join(project_dir, build_dir))
      subject.run
    end

  end

end
