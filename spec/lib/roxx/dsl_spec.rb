require 'roxx/dsl'
require 'roxx/library'
require 'roxx/track'
require 'roxx/audio_mix'
require 'roxx/audio_file'
require 'roxx/audio_file_snippet'
require 'roxx/audio_file_info'
require 'roxx/logger'

module Roxx
  describe "#audio_mix" do
    it "should call AudioMixCommand" do
      Dsl::AudioMixCommand.
        should_receive(:new).
        and_return(stub(:audio_mix_cmd).as_null_object)

      Roxx::audio_mix 

    end
  end
end

module Roxx::Dsl

  describe LibraryCommand do
    context "#audio_file" do
      let(:library) { stub(:library) }
      subject { described_class.new(library) }

      context "given: sound_path exists" do
        it "stores the correct sounds" do
          sound_name, sound_path, audio_file = 
            :sound_1, stub(:sound_path), stub(:audio_file)

          # given: sound_path is sold
          subject.should_receive(:resolve_path).and_return(sound_path)

          Roxx::AudioFile.should_receive(:cache).with(sound_path).and_return(audio_file)
          library.should_receive(:set).with(sound_name, audio_file)

          subject.perform do
            audio_file sound_name, {:path => sound_path}
          end
        end
        context "and: position and duration are specified" do
          it "then: an AudioFileSnippet is added to the library" do
            an_audio_file = stub(:an_audio_file)
            an_audio_file_snippet = stub(:an_audio_file_snippet)

            # given: sound_path is sold
            subject.should_receive(:resolve_path).and_return(stub)

            Roxx::AudioFile.should_receive(:cache).
              and_return(an_audio_file)

            Roxx::AudioFileSnippet.
              should_receive(:cut).
              with(an_audio_file, 10, 20).
              and_return(an_audio_file_snippet)

            library.should_receive(:set).
              with(:sound_1, an_audio_file_snippet)


            subject.perform do
              audio_file :sound_1, {
                :path => 'path/to/nonexisting.mp3',
                :offset => 10,
                :duration => 20
              }
            end
          end
        end
      end
      context "given: sound_path does not exists" do
        it "raises PathDoesNotExist" do
          expect {
            subject.perform do
            audio_file :sound_1, {:path => 'path/to/nonexiting.mp3'}
            end
          }.to raise_error(LibraryCommand::PathDoesNotExist)
        end
      end
      context "given: path argument is missing" do
        it "raises with ArgumentError" do
          sound_name = :sound_1
          expect {
            subject.perform do
            audio_file sound_name, {}
            end
          }.to raise_error(ArgumentError)
        end
      end
      context "given: unknown arguments are passed in" do
        it "raises with ArgumentError" do
          sound_name = :sound_1
          library = stub(:library).as_null_object
          expect {
            subject.perform do
            audio_file sound_name, :path => :blah, :unknown_option => :foo
            end
          }.to raise_error(ArgumentError)

        end
      end
    end
  end

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
