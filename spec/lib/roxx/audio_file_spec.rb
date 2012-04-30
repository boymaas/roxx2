require 'roxx/audio_file_info'
require 'roxx/audio_file'

module Roxx
  describe AudioFile do

    context ".cache" do
      let(:audio_file) { described_class.cache 'path/to/audiofile.wav' }
      it "returns an AudioFile" do
        audio_file.should be_an_instance_of(AudioFile)
      end
      it "resturns same object on second call" do
        audio_file.object_id.should ==
          described_class.cache('path/to/audiofile.wav').object_id
      end
    end

    context ".hash_of_path" do
      it "calculates the hash" do
          described_class.hash_of_path('path/to/audiofile.wav').should ==
            '438deb71b15d8a631acf136878de96df'
      end
    end

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
        Roxx::AudioFileInfo.stub(:new).and_return(audio_file_info)

        audio_file = described_class.new('path/to/audiofile.wav')

        audio_file.duration_in_seconds.should == 10
      end
    end
  end
end
