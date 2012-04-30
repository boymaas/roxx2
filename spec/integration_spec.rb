require 'roxx'

module Roxx
  describe "creating an audiomix" do

    context "#audio_mix" do
      before do
        @audio_mix, @library, @logger = 
          Roxx::audio_mix do 
          library do
            audio_file :sound_1, :path => 'spec/data/test.mp3'
          end
          track :voice do
            sound :sound_1, :offset => 10, :duration => 20
          end
          end
      end

      it "is of correct type"  do
        @audio_mix.should be_an_instance_of(AudioMix)
      end

      context "library" do
        subject { @library } 

        it "stored sound_1" do
          subject.fetch(:sound_1).should be_an_instance_of(AudioFile)
        end
      end

      context "audiomix" do
        subject { @audio_mix }
        it "defined and of correct type" do
          subject.tracks.count.should == 1
          subject.tracks.first.should be_an_instance_of(Track)
        end

        context ".sounds" do
          subject { @audio_mix.tracks.first }
          it "defined and of correct type" do
            subject.sounds.count.should == 1
            subject.sounds.first.should be_an_instance_of(Sound)
          end
        end
      end

    end
  end
end
