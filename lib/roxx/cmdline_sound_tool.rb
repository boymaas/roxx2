module Roxx
  class CmdlineSoundTool
    def determine_duration_in_seconds
      raise "#{self.class}.duration_in_seconds needs to be implemented."
    end
    def execute
      raise "#{self.class}.execute needs to be implemented."
    end

    def sh command
      %x[#{command}]
    end
  end
end
