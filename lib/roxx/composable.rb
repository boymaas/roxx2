# Class abstracting composable behaviour
class Composable
  attr_accessor :children, :parent

  def initialize(parent=:root)
    @children = []
    @parent = parent
  end

  def add_child(child)
    child.parent = self
    self.children << child
  end

  alias :<<  :add_child

  def add_children(children)
    children.each do |child|
      add_child(child)
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
