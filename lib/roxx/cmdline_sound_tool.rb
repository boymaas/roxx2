module Roxx
  class CmdlineSoundTool
    def determine_duration_in_seconds
      raise "#{self.class}.duration_in_seconds needs to be implemented."
    end
  end
end
