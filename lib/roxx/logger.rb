module Roxx
  class Logger
    def log s
      $stderr.puts(s)
      $stderr.flush
    end
  end
end
