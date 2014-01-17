require 'spec_helper'

describe Guard::CMake::CMakeRunner do

  subject { described_class.new(project_dir, build_dir) }

  let(:project_dir) { '/tmp/project1' }
  let(:build_dir) { 'build' }
  let(:command) { double('command', :title => 'command' ) }

  before {
    allow(Kernel).to receive(:system) { true }
    allow(Guard::CMake::CMakeCommand).to receive(:new) { command }
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

    let(:paths) { %w[src/path1/a.cpp src/path2/b.h] }

    context "with no existing makefile" do
      it "builds command with project dir" do
        expect(Guard::CMake::CMakeCommand).to receive(:new).with(project_dir).exactly(1).times.and_return(command)
        subject.run(paths)
      end
    end

    context "with existing makefile", fakefs: true do
      before {
        FileUtils.mkdir_p(File.join(project_dir, build_dir))
        FileUtils.touch(File.join(project_dir, build_dir, 'Makefile'))
      }

      it "does not build command" do
        expect(Guard::CMake::CMakeCommand).to_not receive(:new)
        subject.run(paths)
      end
    end

    it "runs command in build directory" do
      expect(Dir).to receive(:chdir).with(File.join(project_dir, build_dir))
      subject.run(paths)
    end

    context "with no existing makefile and paths contain a CMakeLists.txt file" do
      let(:paths) { %w[src/path1/a.cpp src/path1/CMakeLists.txt src/path2/b.h] }

      it "builds command with project dir" do
        expect(Guard::CMake::CMakeCommand).to receive(:new).with(project_dir).exactly(1).times.and_return(command)
        subject.run(paths)
      end

      it "runs command in build directory" do
        expect(Dir).to receive(:chdir).with(File.join(project_dir, build_dir))
        subject.run(paths)
      end

    end

    context "with existing makefile and paths contain a CMakeLists.txt file", fakefs: true do
      before {
        FileUtils.mkdir_p(File.join(project_dir, build_dir))
        FileUtils.touch(File.join(project_dir, build_dir, 'Makefile'))
      }

      let(:paths) { %w[src/path1/a.cpp src/path1/CMakeLists.txt src/path2/b.h] }

      it "builds command with project dir" do
        expect(Guard::CMake::CMakeCommand).to receive(:new).with(project_dir).exactly(1).times.and_return(command)
        subject.run(paths)
      end

      it "runs command in build directory" do
        expect(Dir).to receive(:chdir).with(File.join(project_dir, build_dir))
        subject.run(paths)
      end

    end

  end

end
