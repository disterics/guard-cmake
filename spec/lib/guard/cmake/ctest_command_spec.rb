require 'spec_helper'

describe Guard::CMake::CTestCommand do

  subject { described_class.new(path) }

  let(:path) { '/tmp/project1/module' }

  describe "#initialize" do
    it 'instantiates with target path' do
      expect(described_class.new(path)).to be
    end

    it 'sets the path' do
      expect(subject.instance_variable_get(:@path)).to be(path)
    end

    it 'runs make with the target path' do
      expect(subject).to match /-C\s#{path}/
    end
  end

end
