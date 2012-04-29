require 'roxx/audio_file_info'

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
