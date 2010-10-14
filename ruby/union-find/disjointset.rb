class DisjointSet
  include Comparable, Enumerable
  attr_accessor :rank, :parent, :payload
  
  def initialize(payload)
    self.rank = 1
    self.parent = self
    self.payload = payload
  end

  def <=>(compareTo)
    @rank <=> compareTo.rank
  end

  def each(&block)
    block.call(self)
    @parent.each(&block) if !self.parent.eql?(self)
  end

  def find
    (@parent.eql?(self) ? @parent : @parent = @parent.find)
  end    
  
  def union(operand)
    root_s = self.find
    root_op = operand.find
    if root_s == root_op
      root_op.parent = root_s
      root_s.rank += 1
    elsif root_s > root_op 
      root_op.parent = root_s
    else
      root_s = root_op
    end
  end
end
