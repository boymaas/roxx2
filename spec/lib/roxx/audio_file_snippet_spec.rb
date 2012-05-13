require 'roxx/audio_file_snippet'

describe Roxx::AudioFileSnippet do
  let(:audio_file) { stub(:audio_file, :duration => 10.0, :path => 'path/to/audio.mp3') }
  context "#cut" do
    subject { described_class.cut(audio_file, 0.0, 10.0) }

    it { should be_an_instance_of(described_class) }
    
  end

  context "#has_offset?" do
    context "given offset > 0.0" do
      subject { described_class.cut(audio_file, 0.1, 10.0) }
      specify { subject.has_offset?.should == true }
    end
    context "given offset == 0.0" do
      subject { described_class.cut(audio_file, 0.0, 10.0) }
      specify { subject.has_offset?.should == false }
    end
  end

  context "#is_a_mp3?" do
    subject { described_class.cut(audio_file, 0.0, 10.0) }
    it "should delegate to audio_file" do
      answer = stub(:answer)
      audio_file.should_receive(:is_a_mp3?).and_return(answer)  
      subject.is_a_mp3?.should == answer
    end
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
  context "#path" do
    subject { described_class.cut(audio_file, 0.0, 10.0) }

    specify {subject.path.should == 'path/to/audio.mp3'}
  end
end
