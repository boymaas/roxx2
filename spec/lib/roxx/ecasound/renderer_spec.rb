require 'roxx/ecasound/domain'
require 'roxx/ecasound/renderer'

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
             :sounds => [sound])
       end

       it "instantialtes the soundchannels" do
         SoundChannel.should_receive(:new).
           with(sound, idx_generator).
           and_return(stub(:channel))

         TrackLoopback.new(track, idx_generator)
       end
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
  end
end
