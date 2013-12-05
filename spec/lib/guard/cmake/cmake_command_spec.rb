require 'spec_helper'

describe Guard::CMake::CMakeCommand do

  subject { described_class.new(project_dir) }

  let(:project_dir) { '/tmp/project1' }

  describe "#initialize" do
    it 'instantiates with project directory' do
      expect(described_class.new(project_dir)).to be
    end

    it 'sets the project directory' do
      expect(subject.instance_variable_get(:@project_dir)).to be(project_dir)
    end

    it 'runs cmake with the project directory' do
      expect(subject).to match /#{project_dir}/
    end
  end


end
