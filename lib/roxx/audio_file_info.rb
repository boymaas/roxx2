require 'roxx/cmdline_ecasound'

module Roxx
  class AudioFileInfo
    attr_reader :path
    def initialize(path, cmdline_sound_tool=nil)
      @path = Pathname.new( path )
      @cmdline_sound_tool = cmdline_sound_tool || CmdlineEcasound.new
      @duration = nil
    end

    def duration
      @duration ||= @cmdline_sound_tool.determine_duration_in_seconds(@path)
    end
  end
end
