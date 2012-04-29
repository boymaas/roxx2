require 'roxx/sound'

describe Roxx::Sound do
  context "#factor" do
    let(:source) { stub(:source) }
    let(:sound) { described_class.factor(source, 10, 20)  }
    it "sets source correctly" do
      sound.source.should == source
    end  
    it "sets duration correctly" do
      sound.duration.should == 20
    end
    it "sets position correctly" do
      sound.position.should == 10
    end
  end
end
