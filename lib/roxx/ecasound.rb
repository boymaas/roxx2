require 'roxx/cmdline_sound_tool'

class Ecasound < CmdlineSoundTool
  def determine_duration_in_seconds(path)
    %x[ecalength -s #{path} 2>/dev/null].chomp.strip.to_f
  end
end
