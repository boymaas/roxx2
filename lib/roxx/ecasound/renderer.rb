module Roxx
  module Ecasound
    class AudioMixRenderer
      def initialize(audio_mix, idx_generator=nil)
        @audio_mix = audio_mix 
        @idx_generator = idx_generator || IdxGenerator.new
        @audio_mix_loopback = AudioMixLoopback.new(@audio_mix, @idx_generator)
      end

      def to_params(target)
        @audio_mix_loopback.to_params +
          ["-a:#{@audio_mix_loopback.idx} -o #{target}"]
      end

      def render(target)
        CmdlineEcasound.execute(to_params(target))
      end
    end

    class AudioMixLoopback < DelegateClass(Loopback)
      def initialize(audio_mix, idx_generator)
        @loopback = Loopback.new(idx_generator)
        @loopback.channels = audio_mix.tracks.map do |track|
          TrackLoopback.new(track, idx_generator)
        end
        super(@loopback)
      end
    end

    class TrackLoopback < DelegateClass(Loopback)
      def initialize(track, idx_generator)
        @loopback = Loopback.new(idx_generator)
        @loopback.channels = track.sounds.map do |sound|
          SoundChannel.new(sound, idx_generator) 
        end
        @loopback.volume = track.volume
        super(@loopback)
      end
    end

    class SoundChannel < DelegateClass(Channel)
      def initialize(sound, idx_generator)
        @sound = sound
        @channel = 
          Channel.factor(idx_generator,
                         sound.position,
                         sound.source.path,
                         sound.source.offset,
                         sound.duration,
                         volume=1.0)
        super(@channel)
      end
    end
  end
end
