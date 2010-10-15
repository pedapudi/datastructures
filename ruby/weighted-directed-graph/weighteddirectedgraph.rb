class WeightedDirectedGraph
  attr_accessor :v, :e, :cycle
  
  def initialize
    @v = []
    @e = []
    @cycle = false
  end

  def add_vertex(payload)
    @v << Vertex.new(payload)
  end

  def add_edge(src, dest, weight)
    new_edge = Edge.new(src,dest, weight)
    src.out_edges << new_edge
    dest.in_edges << new_edge
    @e << new_edge
  end
  
  def has_cycle?
    @cycle
  end

  def explore(start)
    @reset_visits
    start.visited = true 
    start.out_edges.each do |edge|
      edge.dest.visited ? @cycle = true : explore(edge.dest)
    end
  end

  def reset_visits
    @v.each{|v| v.visited = false}
  end
end
class Edge
  attr_accessor :src, :dest, :weight
  
  def initialize(source, destination, weight)
    @src = source
    @dest = destination
    @weight = weight
  end
end

class Vertex
  attr_accessor :in_edges, :out_edges, :payload, :visited
  
  def initialize(*payload)
    @in_edges = []
    @out_edges = []
    @payload = payload if payload
    @visited = false
  end
  
  def in_degree
    @in_edges.length
  end
  
  def out_degree
    @out_edges.length
  end
  
  def degree
    @in_degree + @out_degree
  end
  
  def children
    out_edges.each{|e| e.dest}
  end
  
  def parents
    in_edges.each{|e| e.src}
  end
  
  def to_s
    @payload ? @payload.to_s : self
  end
end
