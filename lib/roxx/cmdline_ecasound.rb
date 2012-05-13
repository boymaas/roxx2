require 'tempfile'
require 'roxx/cmdline_sound_tool'

module Roxx
  class CmdlineEcasound < CmdlineSoundTool
    def determine_duration_in_seconds(path)
      %x[ecalength -s #{path} 2>/dev/null].chomp.strip.to_f
    end

    def execute(params)
      puts %x[ecasound #{params.flatten.join(' ')} | grep ERROR]
    end

    def cut(path, start, duration)
      destination = Tempfile.new(['prepared_sound_', '.mp3'])
      puts %x[ecasound -i #{path} -y #{start} -t #{duration} -o #{destination.path}]
      destination.path
    end
    
    def self.cut(*params)
      new.cut(*params)
    end

    def self.execute(params)
      new.execute(params)
    end
  end
end
