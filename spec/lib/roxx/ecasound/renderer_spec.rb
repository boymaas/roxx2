require 'roxx/ecasound/domain'
require 'roxx/ecasound/renderer'
require 'roxx/cmdline_ecasound'


module Roxx
  module Ecasound
    describe AudioMixRenderer do
      let(:audio_mix) { stub(:audio_mix) }
      let(:idx_generator) { stub(:idx_generator) }
      context "#initialize" do
        it "initialized" do

          AudioMixLoopback.should_receive(:new).with(audio_mix, idx_generator)
          described_class.new(audio_mix, idx_generator)
        end
      end
      context "#render" do
        it "calls the appropiate function" do
          # ingore whole api, is tested at integration
          audio_mix.as_null_object
          described_class.new(audio_mix, idx_generator)
        end
      end
    end

    describe AudioMixLoopback do
      context "#initialize" do
       let(:idx_generator) { stub(:idx_generator) }
       let(:track) { stub(:track) }
       let(:audio_mix) do
         stub(:audio_mix,
             :tracks => [track])
       end

       it "instantialtes the soundchannels" do
         TrackLoopback.should_receive(:new).
           with(track, idx_generator).
           and_return(stub(:loopback))

         AudioMixLoopback.new(audio_mix, idx_generator)
       end
      end
    end

    describe TrackLoopback do
      context "#initialize" do
       let(:idx_generator) { stub(:idx_generator) }
       let(:sound) { stub(:sound) }
       let(:track) do
         stub(:track,
              :volume => 0.5,
             :sounds => [sound])
       end

       let(:track_loopback) { TrackLoopback.new(track, idx_generator) }

       before do
         SoundChannel.should_receive(:new).
           with(sound, idx_generator).
           and_return(stub(:channel))
       end

       specify { track_loopback.volume.should == 0.5}

      end
    end

    describe SoundChannel do
      context "#initialize" do
        let(:idx_generator) { stub(:idx_generator) }
        let(:sound) do
          stub(:sound, 
               :position => 5,
               :duration => 10,
               :source => stub(:source, :path => 'path/to/audio.mp3', :offset => 15))
        end

        subject { described_class.new(sound, idx_generator) }

        specify { subject.start_at.should == 5 }
        specify { subject.volume.should == 1 }
        specify { subject.audio_file_path.should == 'path/to/audio.mp3' }
        specify { subject.offset.should == 15  }
        specify { subject.duration.should == 10  }
      end

    end
    describe PreparedSound do
      # a prepared sound recognizes
      # mp3 files with an offset. If 
      # it encounters an mp3 file with offset
      # it will cut the existing mp3 and wrap it
      # in an AudioFile object as source
      context "#prepare" do
        let(:sound) { stub(:sound) }
        let(:source) { stub(:source, 
                              :duration => 20,
                              :offset => 0.0,
                              :path => 'path/to/audio.mp3') }

        let(:cut_mp3_path) { stub(:cut_mp3_path) }
        subject { described_class.new(sound) }

        context "given: source is NOT an mp3 file" do
          before do
            source.stub(:is_a_mp3? => false)
          end
          it "does not cut when there is offset" do
            source.stub(:has_offset? => true)
            CmdlineEcasound.should_not_receive(:cut)

            subject.prepare(source)
          end
        end

        context "given: source is an mp3 file" do
          before do
            source.stub(:is_a_mp3? => true)
          end
          it "cuts a mp3 file when source has an offset" do
            source.stub(:has_offset? => true)

            CmdlineEcasound.should_receive(:cut).
              with(source.path, source.offset, source.duration).
              and_return(cut_mp3_path)

            subject.prepare(source)
          end

          it "does NOT cut an mp3 file when there offset" do
            source.stub(:has_offset? => false)

            CmdlineEcasound.should_not_receive(:cut)

            subject.prepare(source)
          end
        end
      end
    end
  end

end
