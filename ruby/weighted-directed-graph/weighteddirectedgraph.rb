# this implementation of weighted directed graph has
# the following features:
# * adjacency lists are used for bookkeeping
# * the set of vertices V, the set of edges E are 
#   maintained at all times
# * if dfs is performed, the graph notes whether there
#   exists a cycle or not
# * each node is aware of all the edges leading to it,
#   all the edges leading out of it, and the value it
#   represents
#
# @author Sunil Pedapudi
# @date 10152010

class WeightedDirectedGraph
  attr_accessor :v, :e, :cycle
 
  def initialize
    @v = []
    @e = []
    @cycle = false
  end

  # a vertex is added with a specific payload
  # and the set of all vertices belonging to
  # this graph is updated
  # args
  #    payload: an object to be contained in 
  #    a node
  # return
  #    Vertex object that is created
  def add_vertex(payload)
    @v << Vertex.new(payload)
  end

  # an edge is defined by the source, destination
  # and its weight. when an edge is added, the set 
  # of all edges belonging to this graph is updated.
  # in addition, the nodes at both ends of the edge
  # are updated to acknowledge that there is a new
  # path in the graph
  # args
  #    src: Vertex indicating the starting point
  #    dest: Vertex indicating the ending point
  #    weight: weight of this edge
  # return
  #    Edge object that is created
  def add_edge(src, dest, weight)
    new_edge = Edge.new(src,dest, weight)
    src.out_edges << new_edge
    dest.in_edges << new_edge
    @e << new_edge
  end
  
  # reference to whether there was a cycle the last
  # time it was checked
  def has_cycle?
    @cycle
  end

  # explore performs one iteration of depth-first 
  # search to touch all the nodes accessible from 
  # a specific starting point. this is useful for
  # checking cycles
  # args
  #    start: starting Vertex 
  # return
  #    last Vertex to be touched
  def explore(start)
    self.reset_visits
    start.visited = true 
    start.out_edges.each do |edge|
      edge.dest.visited ? @cycle = true : explore(edge.dest)
    end
  end

  # resets the bookkeeping variable indicating whether
  # a Vertex has been touched or not
  def reset_visits
    @v.each{|v| v.visited = false}
  end
end

# the following definition of an edge is defined by
# a source, destination, and weight
class Edge
  attr_accessor :src, :dest, :weight
  
  def initialize(source, destination, weight)
    @src = source
    @dest = destination
    @weight = weight
  end
end

# the following definition of a vertex abstracts a node
# in a graph. 
class Vertex
  attr_accessor :in_edges, :out_edges, :payload, :visited
  
  # for a more general implementation, the payload is 
  # defined to be an optional parameter, but if a node
  # without a payload exists, its trivial role as a dummy
  # node should be reconsidered
  # args
  #    payload: for all intensive purposes, a required value
  #    that this Vertex will be holding
  def initialize(*payload)
    @in_edges = []
    @out_edges = []
    @payload = payload if payload
    @visited = false
  end
  
  # returns the in-degree of this vertex
  def in_degree
    @in_edges.length
  end
  
  # returns the out-degree of this vertex
  def out_degree
    @out_edges.length
  end
  
  # returns the total degree of this vertex
  def degree
    self.in_degree + self.out_degree
  end
  
  # returns the nodes that are immediately
  # reachable from this vertex
  def children
    out_edges.each{|e| e.dest}
  end
  
  # returns the nodes from which this vertex
  # is immediately reachable
  def parents
    in_edges.each{|e| e.src}
  end
  
  # the string representation of this vertex
  # is the string representation of its
  # payload lest it be undefined. in the latter
  # scenario, the string representation of this
  # Object is utilized
  def to_s
    @payload ? @payload.to_s : self
  end
end
