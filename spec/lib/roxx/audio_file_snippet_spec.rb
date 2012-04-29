require 'roxx/audio_file_snippet'

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
