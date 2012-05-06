require 'roxx/cmdline_sound_tool'

module Roxx
  class CmdlineEcasound < CmdlineSoundTool
    def determine_duration_in_seconds(path)
      %x[ecalength -s #{path} 2>/dev/null].chomp.strip.to_f
    end

    def execute(params)
      puts %x[ecasound #{params.flatten.join(' ')} | grep ERROR]
    end

    def self.execute(params)
      new.execute(params)
    end
  end
end
