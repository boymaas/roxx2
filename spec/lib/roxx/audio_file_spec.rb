require 'roxx/audio_file_info'
require 'roxx/audio_file'

module Roxx
  describe AudioFile do

    let(:audio_file) { described_class.new('path/to/audiofile.wav') }

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

    context "#is_a_mp3?" do
      context "given: is a mp3" do
        let(:audio_file) { described_class.new('path/to/audiofile.mp3') }

        specify { audio_file.is_a_mp3?.should be_true }

      end
      context "given: is NOT a mp3" do
        let(:audio_file) { described_class.new('path/to/audiofile.wav') }

        specify { audio_file.is_a_mp3?.should be_false }
      end
    
    end

    context "#has_offset?" do
      specify {audio_file.has_offset?.should be_false}
    end

    context "#path" do

      it "has a path" do
        audio_file.path.to_s.should == 'path/to/audiofile.wav'
      end
      it "path is a Pathname" do
        audio_file.path.should be_an_instance_of(Pathname)
      end
    end

    context "#duration" do
      it "calculated correct duration" do
        audio_file_info = stub(:audio_file_info)
        audio_file_info.should_receive(:duration).and_return(10)
        Roxx::AudioFileInfo.stub(:new).and_return(audio_file_info)

        audio_file = described_class.new('path/to/audiofile.wav')

        audio_file.duration.should == 10
      end
    end

    context "#offset" do
      let(:audio_file) { described_class.new('path/to/audiofile.wav') }
      specify {audio_file.offset.should == 0.0}
    end
  end
end
