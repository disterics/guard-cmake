require 'spec_helper'

describe Guard::CMake::CMakeRunner do

  subject { described_class.new(project_dir, build_dir) }

  let(:project_dir) { '/tmp/project1' }
  let(:build_dir) { 'build' }
  let(:command) { double('command', :run => true) }

  describe "#initialize" do
    it "instantiates with options" do
      expect(described_class).to receive(:new).with(project_dir, build_dir)
      described_class.new(project_dir, build_dir)
    end
  end

  describe "#run_all" do
    context "with no existing makefile" do
      it "instantiates a new command" do
        expect(Guard::CMake::CMakeCommand).to receive(:new).exactly(1).times.and_return(command)
        subject.run_all
      end

      it "runs the command" do
        Guard::CMake::CMakeCommand.stub(:new) { command }
        expect(command).to receive(:run).exactly(1).times
        subject.run_all
      end
    end

    context "with existing makefile" do
      it "instantiates a new command" do
        expect(Guard::CMake::CMakeCommand).to receive(:new).exactly(1).times.and_return(command)
        subject.run_all
      end

      it "runs the command" do
        Guard::CMake::CMakeCommand.stub(:new) { command }
        expect(command).to receive(:run).exactly(1).times
        subject.run_all
      end
    end
  end

  describe "#run" do
    context "with no existing makefile" do
      it "instantiates a new command" do
        expect(Guard::CMake::CMakeCommand).to receive(:new).exactly(1).times.and_return(command)
        subject.run
      end

      it "runs the command" do
        Guard::CMake::CMakeCommand.stub(:new) { command }
        expect(command).to receive(:run).exactly(1).times
        subject.run
      end
    end

    context "with existing makefile", fakefs: true do
      before {
        FileUtils.mkdir_p(File.join(project_dir, build_dir))
        FileUtils.touch(File.join(project_dir, build_dir, 'Makefile'))
      }

      it "does not instantiate a new command" do
        expect(Guard::CMake::CMakeCommand).to_not receive(:new)
        subject.run
      end
    end
  end

end
