require 'roxx/dsl'
require 'roxx/library'

module Roxx::Dsl

  describe TrackCommand do
    context "#sound" do

      let(:library) { stub(:library) }
      let(:track) { stub(:track) }
      let(:asound) { stub(:sound) }
      let(:logger) { stub(:logger) }

      subject { described_class.new( track, library, logger) }

      context "given: sound is in library" do
        it "configures the sound using defaults when no params supplied" do
          library.should_receive(:fetch).with(:sound_1).and_return(asound)
          track.should_receive(:add_sound).with(asound, 0, nil)

          subject.perform do
            sound :sound_1
          end
        end
        it "configures the sound with the params supplied" do
          library.should_receive(:fetch).with(:sound_1).and_return(asound)
          track.should_receive(:add_sound).with(asound, 10, 20)

          subject.perform do
            sound :sound_1, :offset => 10, :duration => 20
          end
        end
      end
      context "given: unknown options are specified" do
        it "should raise an ArgumentError" do
          expect {
            subject.perform do
            sound :sound_1, :unknown_option => :foo
            end
          }.to raise_error(ArgumentError)
        end
      end
      context "given: sound is NOT in library" do
        it "raises Library::SoundNotFound" do
          library.should_receive(:fetch).
            with(:sound_1).
            and_raise(Roxx::Library::SoundNotFound)

          track.should_not_receive(:add_sound)

          logger.should_receive(:log).with("cannot find sound [sound_1] in library")

          expect {
            subject.perform do
            sound :sound_1
            end
          }.to raise_error( Roxx::Library::SoundNotFound )
        end
      end
    end
  end
end
