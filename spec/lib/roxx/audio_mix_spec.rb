require 'roxx/audio_mix'

describe Roxx::AudioMix do
  it "has tracks" do
    subject.tracks.should == []
  end
  it "has a volume" do
    subject.volume.should == 1
  end

  it "can add tracks" do
    track = stub(:track)
    subject.add_track track
    subject.tracks.should == [ track ]
  end
end
