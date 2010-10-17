# this implementation of weighted directed graph has
# the following features:
# * adjacency lists are used for bookkeeping
# * the set of vertices V, the set of edges E are 
#   maintained at all times
# * each node is aware of all the edges leading to it,
#   all the edges leading out of it, and the value it
#   represents
# * good behavior is expected in utilizing the graph
#   ie. an edge will not include non-existant vertices
#
# @author Sunil Pedapudi
# @date 10152010

class WeightedDirectedGraph
  attr_accessor :v, :e
 
  def initialize
    @v = []
    @e = []
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
    @v << src if !@v.include?(src)
    @v << dest if !@v.include?(dest)
    new_edge = Edge.new(src,dest, weight)
    src.out_edges << new_edge
    dest.in_edges << new_edge
    @e << new_edge
  end
  
  # depth-first search of the graph
  # return
  #    visited: visited[true] for all
  #    nodes successfully visited in
  #    the graph
  def dfs
    visited = Hash.new(false)
    @v.each do |vertex| 
      visited.merge(explore(vertex)) if !visited[vertex]
    end
    return visited
  end
  # explore performs one iteration of depth-first 
  # search to touch all the nodes accessible from 
  # a specific starting point. this is useful for
  # checking cycles
  # args
  #    start: starting Vertex 
  # return
  #    visited: all nodes reachable from start, n, are
  #    indicated by visited[n] = true
  def explore(start)
    visited = Hash.new(false)
    visited[start] = true 
    start.out_edges.each do |edge|
      explore(edge.dest) if !visited[edge.dest]
    end
    return visited
  end
end

# the following definition of an edge is defined by
# a source, destination, and weight
class Edge
  include Comparable
  attr_accessor :src, :dest, :weight
  
  def initialize(source, destination, weight)
    @src = source
    @dest = destination
    @weight = weight
  end
  
  # edges are compared to one another by their
  # weights
  # args
  #    otherEdge: Edge object against which this
  #    edge will be compared to
  # return
  #    1: if this edge's weight is greater
  #    0: if this edge's weight is the same
  #    -1: if this edge's weight is less
  def <=>(otherEdge)
    @weight <=> otherEdge.weight
  end
end

# the following definition of a vertex abstracts a node
# in a graph. 
class Vertex
  attr_accessor :in_edges, :out_edges, :payload
  
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

  # simplicity function since payload is an optional
  # parameter. this returns the actual payload rather
  # than an object containing the payload if payload
  # exists
  def payload
    @payload[0] if @payload
  end
end

# this is a trivial implementation of weighted 
# undirected graphs utilizing the weighted directed
# graph implementation. the logical addition is that
# for every edge added, an edge in the opposite direction
# is also added. 
#
# note that by the weighted directed graph's definition of
# a cycle, any undirected graph will have a cycle. do not
# utilize this definition for weighted undirected graphs.
# also note that the degree of every vertex is twice its
# actual value.

class WeightedUndirectedGraph < WeightedDirectedGraph
  def add_edge(src, dest, weight)
    super(src, dest, weight)
    super(dest, src, weight)
  end
end
