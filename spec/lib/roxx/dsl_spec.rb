require 'roxx/dsl'

module Roxx::Dsl 

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


end
