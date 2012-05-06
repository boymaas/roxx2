require 'delegate'

module Roxx
  module Ecasound

    class AudioMixRenderer
      def initialize(audio_mix)
        @audio_mix = audio_mix 
        @idx_generator = IdxGenerator.new
      end

      def render
        root_loopback = AudioMixLoopback.new(@audio_mix, @idx_generator)
        root_loopback.to_params
      end
    end

    class AudioMixLoopback < DelegateClass(Loopback)
      def initialize(audio_mix, idx_generator)
        @loopback = Loopback.new(@idx_generator)
        @loopback.channels = audio_mix.tracks.map do |track|
          TrackLoopback.new(track, @idx_generator)
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
      end
    end

    class SoundChannel < DelegateClass(Channel)
      def initialize(sound, idx_generator)
        @sound = sound
        @channel = 
          Channel.factor(idx_generator,
                         sound.position,
                         sound.source.path,
                         sound.souce.offset,
                         sound.duration,
                         volume=1.0)
      end
    end

    class Channel
      attr_accessor :volume, :audio_file_path, :start_at, :offset, :duration
      def initialize(idx_generator)
        @idx_generator = idx_generator
        @volume = 1
        @start_at = 0.0
        @offset = 0.0
        @duration = nil
      end
      def idx
        @idx ||= @idx_generator.next_idx
      end

      def self.factor(idx_generator, start_at, audio_file_path, offset, duration, volume=1.0)
        new(idx_generator).tap do |c|
         c.start_at = start_at 
         c.volume = volume 
         c.audio_file_path = audio_file_path
         c.offset = offset
         c.duration = duration
        end
      end

      def to_params
          [ "-a:1 -i playat,#{start_at},select,#{offset},#{duration},#{audio_file_path}",
            "-ea:50" ] * ' '
      end

    end

    class Loopback
      attr_accessor :volume
      attr_accessor :channels
      def initialize(idx_generator)
        @idx_generator = idx_generator
        @volume = 1
        @channels = []
      end

      def idx
        @idx ||= @idx_generator.next_idx
      end

      def to_params
        return [] if @channels.empty?
        @channels.map(&:to_params) + ["-a:#{@channels.map(&:idx) * ','} -o loop,#{idx} -ea:#{volume * 100}"]
      end
    end

    class IdxGenerator
      def initialize
        @current_idx = 0
      end
      def next_idx
        @current_idx += 1
      end
    end
  end
end
