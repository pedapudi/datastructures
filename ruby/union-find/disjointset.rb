
# The following is a rudimentary implementation 
# of a union-find data structure under OOP      
# paradigm.                                     
#                                               
# @author Sunil Pedapudi                        
# @date 10142010                                

# characteristics:
# each instance of class DisjointSet represents 
# a node. each node carries a payload which 
# represents the contents of the node. each node
# also has a rank which, with path compression, is
# an abstract bookkeeping value for all intensive
# purposes. path compression is inherent to this 
# implementation.
#
# DisjointSet instances are enumerable and comparable
# so that common Ruby idioms can be applied to trees of
# nodes. 

class DisjointSet
  include Comparable, Enumerable
  attr_accessor :rank, :parent, :payload

  # optionally, during initialization, a payload may be
  # specified. if no payload is specified, the field
  # will be blank
  # 
  # args
  #     @payload: optional object for this instance
  # return
  #     self
  def initialize(*payload)
    self.rank = 1
    self.parent = self
    self.payload = payload if payload
  end

  # a comparison between two DisjointSet instances is a
  # a comparison between the ranks of the two nodes. for
  # testing equivalence of instances of nodes, please use
  # eql?
  #
  # args
  #    compareTo: an instance of DisjointSet
  # return
  #    1: if self's rank > compareTo's rank
  #    0: if self's rank == compareTo's rank
  #    -1: if self's rank < compareTo's rank
  def <=>(compareTo)
    @rank <=> compareTo.rank
  end

  # the each method applies the given block to self
  # and to all its parents
  #
  # args
  #    &block: a block to be executed on an instance 
  #            of DisjointSet
  # return
  #    result of the block call on root of current node
  def each(&block)
    block.call(self)
    @parent.each(&block) if !self.parent.eql?(self)
  end

  # simplicity function since payload is an optional
  # parameter. this returns the actual payload rather
  # than an object containing the payload if payload
  # exists
  def payload
    @payload[0] if @payload
  end

  # find returns the root parent node of this DisjointSet
  # node. note that this method is responsible for path
  # compression.
  #
  # args
  #    none
  # return
  #    root parent of current node
  def find
    (@parent.eql?(self) ? @parent : @parent = @parent.find)
  end    
  
  # union joins the trees to which self and operand belong
  #
  # args
  #    operand: an instance of DisjointSet
  # return
  #    parent root of the tree after the union
  def union(operand)
    root_s = self.find
    root_op = operand.find
    if !root_s.eql?(root_op)
      if root_s == root_op
        root_op.parent = root_s
        root_s.rank += 1
      elsif root_s > root_op 
        root_op.parent = root_s
      else
        root_s.parent = root_op
      end
    end
  end
end
