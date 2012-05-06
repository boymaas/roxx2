require 'roxx/dsl'
require 'roxx/library'
require 'roxx/audio_mix'
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

