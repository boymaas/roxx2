require 'roxx/composable'

class CmdlineSoundTool
  def determine_duration_in_seconds
    raise "#{self.class}.duration_in_seconds needs to be implemented."
  end
end

class EcaSound < CmdlineSoundTool
  def determine_duration_in_seconds(path)
    %x[ecalength -s #{path} 2>/dev/null].chomp.strip.to_f
  end
end

class AudioFileInfo
  attr_reader :path
  def initialize(path, cmdline_sound_tool=nil)
    @path = Pathname.new( path )
    @cmdline_sound_tool = cmdline_sound_tool || EcaSound.new
    @duration_in_seconds = nil
  end

  def duration_in_seconds
      @duration_in_seconds ||= @cmdline_sound_tool.determine_duration_in_seconds(@path)
  end
end

class AudioFile
  attr_reader :path

  def initialize(path)
    @path = Pathname.new(path)
    @audio_file_info = AudioFileInfo.new(path)
  end

  def duration_in_seconds
    @audio_file_info.duration_in_seconds
  end
end

class AudioFileSnippet
  attr_reader :offset, :duration_in_seconds
  def initialize(audio_file, offset, duration_in_seconds)
    @audio_file = audio_file
    @offset = offset
    @duration_in_seconds = duration_in_seconds
  end

  def self.cut(audio_file, offset, duration)
    new(audio_file, offset, duration)
  end

end

class Sound
  attr_reader :source, :position, :duration

  def initialize(source, position, duration)
    @source = source
    @position = position
    @duration = duration
  end

  def self.factor(source, pos, duration)
    new(source, pos, duration)
  end
end

class Track
  attr_accessor :sounds, :volume

  def initialize
    @sounds = []
    @volume = 1
  end

  def add_sound(source, pos, duration)
    @sounds << Sound.factor(source,pos,duration)
  end

end

class AudioMix
  attr_accessor :tracks, :volume

  def initialize
    @tracks = []
    @volume = 1
  end

  def add_track track
    @tracks << track
  end

end

class Renderer
end

describe AudioFileInfo do
  before do
    described_class.new('path/to/audiofile.wav') 
  end
  context "#path" do
    let(:audio_file_info) { described_class.new('path/to/audiofile.wav') }

    it "returns correct path" do
      audio_file_info.path.to_s.should == 'path/to/audiofile.wav'
    end
    it "path is a Pathname" do
      audio_file_info.path.should be_an_instance_of(Pathname)
    end
  end
  context "#duration_in_seconds" do
    it "calculates correct duration" do
      cmdline_soundtool = stub(:cmdline_sound_tool)
      cmdline_soundtool.should_receive(:determine_duration_in_seconds).and_return(2)

      audio_file_info = described_class.new('spec/to/audiofile.wav', cmdline_soundtool)

      audio_file_info.duration_in_seconds.should == 2
    end
  end
end

describe AudioFile do

  context "#path" do
    let(:audio_file) { described_class.new('path/to/audiofile.wav') }

    it "has a path" do
      audio_file.path.to_s.should == 'path/to/audiofile.wav'
    end
    it "path is a Pathname" do
      audio_file.path.should be_an_instance_of(Pathname)
    end
  end

  context "#duration_in_seconds" do
    it "calculated correct duration" do
      audio_file_info = stub(:audio_file_info)
      audio_file_info.should_receive(:duration_in_seconds).and_return(10)
      AudioFileInfo.stub(:new).and_return(audio_file_info)

      audio_file = described_class.new('path/to/audiofile.wav')

      audio_file.duration_in_seconds.should == 10
    end
  end
end

describe AudioFileSnippet do
  let(:audio_file) { stub(:audio_file, :duration_in_seconds => 10.0) }
  context "#cut" do
    subject { described_class.cut(audio_file, 0.0, 10.0) }

    it { should be_an_instance_of(AudioFileSnippet) }
    
  end
  context "#offset" do
    subject { described_class.cut(audio_file, 0.0, 10.0) }

    it "starts at 0.0" do
      subject.offset.should == 0.0
    end
  end
  context "#duration_in_seconds" do
    subject { described_class.cut(audio_file, 0.0, 10.0) }

    it "has a duration" do
      subject.duration_in_seconds.should == 10.0
    end
  end
end

describe Sound do
  context "#factor" do
    let(:source) { stub(:source) }
    let(:sound) { Sound.factor(source, 10, 20)  }
    it "sets source correctly" do
      sound.source.should == source
    end  
    it "sets duration correctly" do
      sound.duration.should == 20
    end
    it "sets position correctly" do
      sound.position.should == 10
    end
  end
end

describe Track do
  it "has sounds" do
    subject.sounds.should == []
  end
  it "has a volume" do
    subject.volume.should == 1
  end
  context "when a sound is added" do
    it "correct sound is factored" do
      source, pos, duration = stub(:source), 0, 10

      sound = stub(:sound)
      Sound.should_receive(:factor).with(source, pos, duration).and_return(sound)

      subject.add_sound(source, pos, duration)

      added_sound = subject.sounds.first 
      added_sound.should == sound
    end
  end
end

describe AudioMix do
  it "has tracks" do
    subject.tracks.should == []
  end
  it "has a volume" do
    subject.volume.should == 1
  end

  it "can add tracks" do
    track = stub(:track)
    subject.add_track track
    subject.tracks.should == [ track ]
  end
end

describe Renderer do
end
