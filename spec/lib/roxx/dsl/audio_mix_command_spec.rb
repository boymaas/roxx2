require 'roxx/dsl'
require 'roxx/track'

module Roxx::Dsl

  describe AudioMixCommand do

    let(:audio_mix) { stub(:audio_mix) }
    let(:library) { stub(:library) }
    let(:logger) { stub(:logger) }
    let(:track) { stub(:track) }

    subject { described_class.new( audio_mix, library, logger) }

    context "#library" do
      it "evaluates the library block" do
        code_block = stub(:code_block)
        LibraryCommand.should_receive(:new).with(library).and_return(stub.as_null_object)
        subject.perform do
          library do
            audio_file :sound_1
          end
        end
      end

    end
    context "#track" do
      it "evaluates the track block" do
        Roxx::Track.stub(:new => track)
        TrackCommand.should_receive(:new).with(track,library,logger).and_return(stub.as_null_object)
        audio_mix.should_receive(:add_track).with(track)

        subject.perform do
          track :track_1 do
            sound :sound_1
          end
        end
      end
    end
  end
end
