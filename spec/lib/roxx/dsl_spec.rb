require 'roxx/dsl'
require 'roxx/library'
require 'roxx/track'
require 'roxx/audio_mix'
require 'roxx/audio_file'
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

  # audio_mix do
  #   library do
  #     # no params implies whole file
  #     audio_file :sound_1, :path => 'path/to/sound.mp3'
  #     # no duration implies usable untill end
  #     audio_file :sound_2, :path => 'path/to/sound.mp3', :offset => 10
  #     # offset and duration 
  #     audio_file :sound_3, :path => 'path/to/sound.mp3', :offset => 10, :duration => 2.2
  #   end
    
  #   duration 20.minutes

  #   effect :fade_in, :slope => 10.seconds
  #   effect :fade_out, :slope => 10.seconds

  #   track :voice do
  #     # no duration will play whole track 
  #     sound :sound_1
  #     # duration specified will loop sound_3 for 10 minutes
  #     sound :sound_3, :duration => 10.minutes
  #   end

  #   track :background do
  #     # will repeat until length of audio mix
  #     sound :sound_3, :duration => :audio_mix
  #   end
  # end

  describe LibraryCommand do
    context "#audio_file" do
      let(:library) { stub(:library) }
      subject { described_class.new(library) }
      it "stores the correct sounds" do
        sound_name, sound_path, audio_file = 
          :sound_1, stub(:sound_path), stub(:audio_file)

        subject.should_receive(:resolve_path).and_return(sound_path)
        
        Roxx::AudioFile.should_receive(:cache).with(sound_path).and_return(audio_file)
        library.should_receive(:set).with(sound_name, audio_file)

        subject.perform do
          audio_file sound_name, {:path => sound_path}
        end
      end
      it "raises when path argument is missing" do
        sound_name = :sound_1
        expect {
          subject.perform do
            audio_file sound_name, {}
          end
        }.to raise_error(ArgumentError)
      end
      it "raises when unknown arguments are passed" do
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

  describe TrackCommand do
    context "#sound" do

      let(:library) { stub(:library) }
      let(:track) { stub(:track) }
      let(:asound) { stub(:sound) }
      let(:logger) { stub(:logger) }

      subject { described_class.new( track, library, logger) }

      context "when sound is in library" do
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
      context "when unknown options specified" do
        it "should raise" do
          expect {
            subject.perform do
            sound :sound_1, :unknown_option => :foo
            end
          }.to raise_error(ArgumentError)
        end
      end
      context "when sound is not in lib" do
        it "raises Library::SoundNotFound" do
          library.should_receive(:fetch).with(:sound_1).and_raise(Roxx::Library::SoundNotFound)
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
