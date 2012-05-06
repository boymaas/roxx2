require 'roxx/dsl/command'
require 'roxx/dsl/library_command'
require 'roxx/dsl/track_command'
require 'roxx/dsl/audio_mix_command'

module Roxx

  def self.audio_mix options={}, &block
    logger    = options.delete(:logger)      || Roxx::Logger.new
    library   = options.delete(:library)     || Roxx::Library.new
    audio_mix = options.delete(:audio_mix)   || Roxx::AudioMix.new

    Dsl::AudioMixCommand.new(audio_mix, library, logger).perform(&block)

    [ audio_mix, library, logger ]
  end

end
