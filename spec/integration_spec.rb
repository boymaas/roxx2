require 'roxx'
require 'roxx/ecasound/domain'
require 'roxx/ecasound/renderer'

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
              sound :sound_1, :offset =>  0, :duration => 20
              sound :sound_2, :offset => 0, :duration => 10
              volume = 1
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

        context "when combining mixes" do
          context "given: we pass the original audio_mix and library" do
            before do 
              @audio_mix, @library = Roxx::audio_mix :audio_mix => @audio_mix, :library => @library  do
                track :extra do
                  sound :sound_2, :offset => 0, :duration => 10
                end
              end
            end 

            it "then track should be added to original audiomix" do
               @audio_mix.tracks.count.should == 2 
            end

          end
        end

        context ".sounds" do
          subject { @audio_mix.tracks.first }

          specify { subject.sounds.count.should == 2 }
          specify { subject.sounds.first.should be_an_instance_of(Sound) }
        end
      end

      context "renderer" do
        before do
          @audio_mix, = Roxx::audio_mix do 
            library do
              audio_file :sound_1, :path => 'spec/data/test.mp3'
              audio_file :sound_2, :path => 'spec/data/test.mp3'
            end
            track :voice do
              [5,10,15,20].each do |offset| 
                sound :sound_1, :offset =>  offset, :duration => 5
              end
            end
            track :other do
              sound :sound_2, :offset =>  0, :duration => 25 
              volume 0.2
            end
          end
        end

        it "volume on track should be 0.2" do
          @audio_mix.tracks[1].volume.should == 0.2
        end

        it "renders the audio_mix" do
          renderer = Ecasound::AudioMixRenderer.new(@audio_mix)
          renderer.render('spec/output/target.mp3').should == ''
        end

      end
    end
  end
end
