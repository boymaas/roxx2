require 'roxx/dsl'
require 'roxx/library'
require 'roxx/track'
require 'roxx/audio_mix'
require 'roxx/logger'

module Roxx
  describe "#audio_mix" do
    it "should call AudioMixCommand" do
      Dsl::Classes::AudioMixCommand.should_receive(:new)

      Roxx::audio_mix do
        library do
        end
      end
    end
  end
end

module Roxx::Dsl::Classes

  # audio_mix do
  #   library do
  #     # no params implies whole file
  #     set :sound_1, :path => 'path/to/sound.mp3'
  #     # no duration implies usable untill end
  #     set :sound_2, :path => 'path/to/sound.mp3', :offset => 10
  #     # offset and duration 
  #     set :sound_3, :path => 'path/to/sound.mp3', :offset => 10, :duration => 2.2
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
    it "stores the correct sounds" do
      sound_name = :sound_1
      sound_options = {:path => 'path/to/sound.mp3'}

      library = stub(:library)
      library.should_receive(:set).with(sound_name, sound_options)

      LibraryCommand.new library do
        set sound_name, sound_options
      end
    end
  end

  describe TrackCommand do
    context "#sound" do

      let(:library) { stub(:library) }
      let(:track) { stub(:track) }
      let(:asound) { stub(:sound) }
      let(:logger) { stub(:logger) }

      context "when sound is in library" do
        it "configures the sound using defaults when no params supplied" do
          library.should_receive(:fetch).with(:sound_1).and_return(asound)
          track.should_receive(:add_sound).with(asound, 0, nil)

          described_class.new track, library, logger do
            sound :sound_1
          end
        end
        it "configures the sound with the params supplied" do
          library.should_receive(:fetch).with(:sound_1).and_return(asound)
          track.should_receive(:add_sound).with(asound, 10, 20)

          described_class.new track, library, logger do
            sound :sound_1, :offset => 10, :duration => 20
          end
        end
      end
      context "when unknown options specified" do
        it "should raise" do
          expect {
            described_class.new track, library, logger do
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
            described_class.new track, library, logger do
              sound :sound_1
            end
          }.to raise_error( Roxx::Library::SoundNotFound )
        end
      end
    end
  end

  describe AudioMixCommand do

    let(:library) { stub(:library) }
    let(:audio_mix) { stub(:audio_mix) }
    let(:logger) { stub(:logger) }

    context "#library" do
      it "evaluates the library block" do
        library = stub(:library)
        code_block = stub(:code_block)
        LibraryCommand.should_receive(:new).with(library) # and code block
        described_class.new audio_mix, library, logger do
          library do
            set :sound_1
          end
        end
      end
      
    end
    context "#track" do
      it "evaluates the track block" do
        atrack = stub(:track)
        Roxx::Track.stub(:new => atrack)
        TrackCommand.should_receive(:new).with(atrack,library,logger)
        audio_mix.should_receive(:add_track).with(atrack)

        described_class.new audio_mix, library, logger do
          track :track_1 do
            sound :sound_1
          end
        end
      end
    end
  end

end
