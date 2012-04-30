require 'roxx'

describe "creating an audiomix" do

  context "#audio_mix" do
    let(:an_audio_mix) do
      Roxx::audio_mix do 
        library do
          set :sound_1, :path => 'path/to/sound.mp3'
        end
        track :voice do
          sound :sound_1, :offset => 10, :duration => 20
        end
      end
    end

    it "is of correct type"  do
      an_audio_mix.should be_an_instance_of(Roxx::AudioMix)
    end

    context ".tracks" do
      subject { an_audio_mix }
      it "defined and of correct type" do
        subject.tracks.count.should == 1
        subject.tracks.first.should be_an_instance_of(Roxx::Track)
      end

      context ".sounds" do
        subject { an_audio_mix.tracks.first }
        it "defined and of correct type" do
          subject.sounds.count.should == 1
          subject.sounds.first.should be_an_instance_of(Roxx::Sound)
        end
      end
    end

  end
end
