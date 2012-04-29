require 'roxx/sound'
require 'roxx/track'

describe Track do
  it "has sounds" do
    subject.sounds.should == []
  end
  it "has a volume" do
    subject.volume.should == 1
  end
  context "when a sound is added" do
    it "correct sound is factored" do
      source, pos, duration = stub(:source), 0, 10

      sound = stub(:sound)
      Sound.should_receive(:factor).with(source, pos, duration).and_return(sound)

      subject.add_sound(source, pos, duration)

      added_sound = subject.sounds.first 
      added_sound.should == sound
    end
  end
end
