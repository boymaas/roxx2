class Source
  attr_accessor :children, :parent

  def initialize(parent=:root)
    @children = []
    @parent = parent
  end

  def addChild(child)
    child.parent = self
    self.children << child
  end

  alias :<<  :addChild

  def addChildren(children)
    children.each do |child|
      addChild(child)
    end
  end

  def pre_walk(&block)
    values = [ block.call(self) ]
    children.each do |chld| 
      values += chld.pre_walk(&block) 
    end
    values
  end

  def post_walk(&block)
    values = []
    children.each do |chld| 
      values += chld.post_walk(&block) 
    end
    values += [ block.call(self) ]
    values
  end
end

class RoxxDefinition < Source
end

class Renderer
end

describe Source do
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
  context "#addChild" do
    let(:added_source) {Source.new}
    let(:root) do
      subject.addChild(added_source)    
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
    it "adds children" do
      root = Source.new
      root << ( added_source = Source.new )

      root.children.first.should == added_source 
    end
  end

  context "#addChildren" do
    it "should call addChild number of times" do
      subject.should_receive(:addChild).exactly(3).times
      subject.addChildren([stub,stub,stub])
    end
  end

  context "walking the tree" do
    def generate_sources count, parent=nil
      Array.new(count) { Source.new(parent) }
    end
    let(:children0) { generate_sources(2) }
    let(:children1) { generate_sources(2) }
    let(:root) do
      root = Source.new()
      root.addChildren( children0 )
      root.children[0].addChildren( children1 )
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

describe RoxxDefinition do
  it "has children" do
    subject.children.should == []
  end
end

describe Renderer do
end
