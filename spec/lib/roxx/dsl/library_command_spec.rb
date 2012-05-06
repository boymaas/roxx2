require 'roxx/dsl'
require 'roxx/audio_file'
require 'roxx/audio_file_snippet'

module Roxx::Dsl

  describe LibraryCommand do
    context "#audio_file" do
      let(:library) { stub(:library) }
      subject { described_class.new(library) }

      context "given: sound_path exists" do
        it "stores the correct sounds" do
          sound_name, sound_path, audio_file = 
            :sound_1, stub(:sound_path), stub(:audio_file)

          # given: sound_path is sold
          subject.should_receive(:resolve_path).and_return(sound_path)

          Roxx::AudioFile.should_receive(:cache).with(sound_path).and_return(audio_file)
          library.should_receive(:set).with(sound_name, audio_file)

          subject.perform do
            audio_file sound_name, {:path => sound_path}
          end
        end
        context "and: position and duration are specified" do
          it "then: an AudioFileSnippet is added to the library" do
            an_audio_file = stub(:an_audio_file)
            an_audio_file_snippet = stub(:an_audio_file_snippet)

            # given: sound_path is sold
            subject.should_receive(:resolve_path).and_return(stub)

            Roxx::AudioFile.should_receive(:cache).
              and_return(an_audio_file)

            Roxx::AudioFileSnippet.
              should_receive(:cut).
              with(an_audio_file, 10, 20).
              and_return(an_audio_file_snippet)

            library.should_receive(:set).
              with(:sound_1, an_audio_file_snippet)


            subject.perform do
              audio_file :sound_1, {
                :path => 'path/to/nonexisting.mp3',
                :offset => 10,
                :duration => 20
              }
            end
          end
        end
      end
      context "given: sound_path does not exists" do
        it "raises PathDoesNotExist" do
          expect {
            subject.perform do
            audio_file :sound_1, {:path => 'path/to/nonexiting.mp3'}
            end
          }.to raise_error(LibraryCommand::PathDoesNotExist)
        end
      end
      context "given: path argument is missing" do
        it "raises with ArgumentError" do
          sound_name = :sound_1
          expect {
            subject.perform do
            audio_file sound_name, {}
            end
          }.to raise_error(ArgumentError)
        end
      end
      context "given: unknown arguments are passed in" do
        it "raises with ArgumentError" do
          sound_name = :sound_1
          library = stub(:library).as_null_object
          expect {
            subject.perform do
            audio_file sound_name, :path => :blah, :unknown_option => :foo
            end
          }.to raise_error(ArgumentError)

        end
      end
    end
  end
end
