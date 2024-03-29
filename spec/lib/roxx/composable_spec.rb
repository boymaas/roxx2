require 'roxx/composable'

describe Roxx::Composable do
  context "#children" do
    it "is initialized with an array" do
      subject.children.should == []
    end
  end
  context "#parent" do
    it "is initialized with symbol :root" do
      subject.parent.should == :root
    end
  end
  context "#add_child" do
    let(:added_source) {described_class.new}
    let(:root) do
      subject.add_child(added_source)    
      subject
    end
    it "adds a child" do
      root.children[0].should == added_source
    end
    it "sets the parent" do
      root.children[0].parent.should == root
    end
  end

  context "#<<" do
    it "adds a child" do
      root = described_class.new
      root << ( added_source = described_class.new )

      root.children.first.should == added_source 
    end
  end

  context "#add_children" do
    it "should call add_child number of times" do
      subject.should_receive(:add_child).exactly(3).times
      subject.add_children([stub,stub,stub])
    end
  end

  context "walking the tree" do
    def generate_sources count, parent=nil
      Array.new(count) { described_class.new(parent) }
    end
    let(:children0) { generate_sources(2) }
    let(:children1) { generate_sources(2) }
    let(:root) do
      root = described_class.new()
      root.add_children( children0 )
      root.children[0].add_children( children1 )
      root
    end

    context "#pre_walk" do
      it "traverses the tree head first" do
        values = root.pre_walk do |chld|
          chld.object_id
        end
        values.should == ( [root] + 
                             [ children0[0] ] + 
                                 children1 + 
                             children0[1..-1] ).map(&:object_id)
      end
    end

    context "#post_walk" do
      it "traverses the tree head last" do
        values = root.post_walk do |chld|
          chld.object_id
        end
        values.should == ( children1 + children0 + [root] ).map(&:object_id)
      end
    end

  end
end
