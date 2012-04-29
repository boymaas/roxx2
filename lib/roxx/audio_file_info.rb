require 'roxx/ecasound'

module Roxx
  class AudioFileInfo
    attr_reader :path
    def initialize(path, cmdline_sound_tool=nil)
      @path = Pathname.new( path )
      @cmdline_sound_tool = cmdline_sound_tool || Ecasound.new
      @duration_in_seconds = nil
    end

    def duration_in_seconds
      @duration_in_seconds ||= @cmdline_sound_tool.determine_duration_in_seconds(@path)
    end
  end
end
