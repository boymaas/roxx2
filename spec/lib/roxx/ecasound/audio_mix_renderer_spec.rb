require 'roxx/ecasound/audio_mix_renderer'

# Ecasound renderer
# =================
#
# ecasound is a commandline tool capable of rendering complex audiostreams
# our ecasound renderer will render an audiomix.
#
# ecasound is capable of rendering complex compositions in one go. To do this
# it uses channels and loopback devices
#
# In the audiomix domain:
#   AudioMix
#     Track
#       Sounds
#
# In which AudioMix and Tracks are Loopbacks and Sounds are channels
#
# So we could say that:
#
#   AudioMix          ..becomes...     Loopback
#     Track                              Loopback
#       Sounds                             Channel
#
# Rendering will now consist of just rendering all children of the root Loopback
# recursively. That is call to_param on them.
#
# AudioMixRenderer
# ================
#
# The renderer will now only contain the logic to transfer from
# an AudioMix structure to an EcaSound loopback structure.
#
# IdxGenerator
#
# Loopback
#   idx
#   channels
#   volume
#   to_params
#
# Channel
#   idx
#   audio_file_path
#   start_at
#   offset
#   duration
#   volume
#   to_params
#
# AudioMixLoopback
#   @audio_mix
#
# TrackLoopback
#   @track
#
# SoundChannel
#   @sound


module Roxx::Ecasound
  describe IdxGenerator do
    it "generates unique ids" do
      subject.next_idx.should == 1
      subject.next_idx.should == 2
    end
  end
  
  describe Loopback do
    let(:idx_generator) { stub(:idx_generator) }
    subject { described_class.new(idx_generator)}

    specify {subject.volume.should == 1}
    specify {subject.channels.should == []}

    context "#idx" do
      it "calls next_idx to get new id" do
        idx_generator.should_receive(:next_idx).and_return(1)
        subject.idx.should == 1
      end
      it "caches the previous one" do
        idx_generator.stub(:next_idx=>1)
        subject.idx # call once
        idx_generator.should_not_receive(:next_idx)
        subject.idx.should == 1
      end
    end

    context "#to_params" do
      context "given: no channels avaiable" do
        it "returns empty string" do
          subject.to_params.should == []
        end  
      end
      context "given: 1 channel available"  do
        it "returns the correct parameter" do
          subject.channels << stub(:channel, :idx => 2,
                                   :to_params => [ :channel_params ]) 
          subject.stub(:idx => 1)

          subject.to_params.should == [[ :channel_params ], "-a:2 -o 1"]
        end
        
      end
      context "given: >1 channels available" do
        it "returns the correct parameters" do
          (2..3).map do |idx|
            subject.channels << stub(:channel, :idx => idx,
                                     :to_params => [ :channel_params ]) 
          end

          subject.stub(:idx => 1)

          subject.to_params.should == [
            [ :channel_params ],
            [ :channel_params ],
            "-a:2,3 -o 1"]
        end
      end
      
    end
  end

  describe AudioMixRenderer do
    context "#initialize" do
      it "takes an audio_mix" do
        audio_mix = stub(:audio_mix) 
        described_class.new(audio_mix)
      end
    end
  end

end
