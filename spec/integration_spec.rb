require 'roxx'

module Roxx
  describe "creating an audiomix" do

    context "#audio_mix" do
      before do
        @audio_mix, @library, @logger = 
          Roxx::audio_mix do 
            library do
              audio_file :sound_1, :path => 'spec/data/test.mp3'
              audio_file :sound_2, :path => 'spec/data/test.mp3', :offset => 10
              audio_file :sound_3, :path => 'spec/data/test.mp3', 
                                   :offset => 10,
                                   :duration => 20
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


        context "sound_1" do
          subject { @library.fetch(:sound_1) }

          specify { subject.should be_an_instance_of(AudioFile) }
          specify { subject.duration.should be_within(0.04).of(295.393) }
        end

        context "sound_2" do
          subject { @library.fetch(:sound_2) }
          specify { subject.should be_an_instance_of(AudioFileSnippet) }
          specify { subject.duration.should be_within(0.04).of(285.393) }
        end
        context "sound_3" do
          subject { @library.fetch(:sound_3) }
          specify { subject.should be_an_instance_of(AudioFileSnippet) }
          specify { subject.duration.should == 20 }
        end

      end

      context "audiomix" do
        subject { @audio_mix }

        specify { subject.tracks.count.should == 1 }
        specify { subject.tracks.first.should be_an_instance_of(Track) }

        context ".sounds" do
          subject { @audio_mix.tracks.first }

          specify { subject.sounds.count.should == 1 }
          specify { subject.sounds.first.should be_an_instance_of(Sound) }
        end
      end

    end
  end
end
