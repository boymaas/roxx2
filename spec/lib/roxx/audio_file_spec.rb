require 'roxx/audio_file_info'
require 'roxx/audio_file'

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
