require 'roxx/sound'

describe Roxx::Sound do
  context "#factor" do

    context "given: duration is specified"do
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

      context "#end_time" do
        it "calculates end_time correctly" do
          sound.end_time.should == 30
        end
      end
      context "#start_time" do
        it "calculates start_time correctly" do
          sound.start_time.should == 10
        end
      end
    end

    context "given: duration is not specified" do
      it "fetches the duration of the source" do
        source = stub(:source)
        sound = described_class.factor(source, 10)

        source.should_receive(:duration).and_return(20)

        sound.duration.should == 20
      end
      
    end
  end
end
