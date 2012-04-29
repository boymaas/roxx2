require 'roxx/library'

module Roxx
  describe Library do
    before do
      subject.set :label, :value    
    end
    context "#set" do
      it "stores the value" do
        value = subject.fetch :label
        value.should == :value
      end
    end
    context "#fetch" do
      it "fetches the correct value" do
        value = subject.fetch :label
        value.should == :value
      end
    end
  end
end
