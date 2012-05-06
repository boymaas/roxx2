require 'roxx/sound'
require 'roxx/track'

# require 'active_support'

describe Roxx::Track do
  it "has sounds" do
    subject.sounds.should == []
  end
  it "has a volume" do
    subject.volume.should == 1
  end
  context "#add_sound" do
    it "sound is added to store" do
      source, pos, duration = stub(:source), 0, 10

      sound = stub(:sound)
      Roxx::Sound.should_receive(:factor).with(source, pos, duration).and_return(sound)

      subject.add_sound(source, pos, duration)

      added_sound = subject.sounds.first 
      added_sound.should == sound
    end
  end

  context "#duration" do
    context "given: source(s) with explicit position and duration are are" do
      context "and: one sound is added" do
        it "calculates the correct duration" do
          source, pos, duration = stub(:source), 10, 20
          subject.add_sound(source, pos, duration)    

          subject.duration.should == 30
        end
      end
      context "and: two or more sounds are added" do
        it "calculates the correct duration" do
          source = stub(:source)
          subject.add_sound(source, 10, 20 )    
          subject.add_sound(source, 20, 30)    

          subject.duration.should == 50
        end
      end
    end
    context "given: source(s) with explicit position and duration are are" do
      context "and: one sound is added" do
        it "calculates the correct duration" do
          source = stub(:source)
          source.should_receive(:duration).and_return(20)
          subject.add_sound(source, 10)
          subject.duration.should == 30
        end
      end
    end
    context "given: duration is specified on track" do
      context "and: one sound is added" do
        it "then: track duration should override sound durations" do
          source = stub(:source, :duration => 50)
          subject.add_sound(source, 10)

          subject.duration = 20
          subject.duration.should == 20
          
        end
      end
    end
  end
end
