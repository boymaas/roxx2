require 'roxx/audio_mix'

describe Roxx::AudioMix do
  it "has tracks" do
    subject.tracks.should == []
  end
  it "has a volume" do
    subject.volume.should == 1
  end

  context "#add_track" do
    it "can add tracks" do
      track = stub(:track)
      subject.add_track track
      subject.tracks.should == [ track ]
    end
  end

  context "#duration" do
    context "given: one track with duration added" do
      it "calculates duration correctly" do
        track = stub(:track)
        track.should_receive(:duration).and_return(50)
        subject.add_track track

        subject.duration.should == 50
      end
    end
    context "given: multiple tracks with duration added" do
      it "calculates duration correctly" do
        track1 = stub(:track, :duration => 10)
        track2 = stub(:track, :duration => 20)
        subject.add_track track1
        subject.add_track track2
        subject.duration.should == 20
      end
    end
    context "given: duration is specified on track" do
      it "track duration overrides specified sound duration" do
        track = stub(:track, :duration => 10)
        subject.add_track track

        subject.duration = 5

        subject.duration.should == 5
        
      end
    end
  end
end
