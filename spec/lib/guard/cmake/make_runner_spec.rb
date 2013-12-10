require 'spec_helper'

describe Guard::CMake::MakeRunner do

  subject { described_class.new(project_dir, build_dir) }

  let(:project_dir) { 'tmp/project1' }
  let(:build_dir) { 'build' }
  let(:command) { double('command', :title => 'command' ) }
  let(:full_build_path) { File.join(project_dir, build_dir) }

  before {
    allow(Kernel).to receive(:system) { true }
    allow(Guard::CMake::MakeCommand).to receive(:new) { command }
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
      expect(Guard::CMake::MakeCommand).to receive(:new).with(nil).exactly(1).times.and_return(command)
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
      expect(Guard::CMake::MakeCommand).to receive(:new).with(File.dirname(paths[0])).ordered.and_return(command)
      expect(Guard::CMake::MakeCommand).to receive(:new).with(File.dirname(paths[1])).ordered.and_return(command)
      subject.run(paths)
    end

    it "runs command in build directory" do
      expect(Dir).to receive(:chdir).with(full_build_path)
      subject.run(paths)
    end
  end

end
