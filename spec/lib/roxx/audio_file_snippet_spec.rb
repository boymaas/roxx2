require 'roxx/audio_file_snippet'

describe Roxx::AudioFileSnippet do
  let(:audio_file) { stub(:audio_file, :duration => 10.0) }
  context "#cut" do
    subject { described_class.cut(audio_file, 0.0, 10.0) }

    it { should be_an_instance_of(described_class) }
    
  end
  context "#offset" do
    subject { described_class.cut(audio_file, 0.0, 10.0) }

    it "starts at 0.0" do
      subject.offset.should == 0.0
    end
  end
  context "#duration" do
    subject { described_class.cut(audio_file, 0.0, 10.0) }

    it "has a duration" do
      subject.duration.should == 10.0
    end
    context "given: no duration is specified" do
      let(:audio_file) { stub(:audio_file, :duration => 50.0) }
      subject { described_class.cut(audio_file, 10.0, nil) }

      specify { subject.duration.should == 40 }
        
    end
  end
end
