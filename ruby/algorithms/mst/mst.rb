module MinimumSpanningTree
  def kruskal(g)
    mst = WeightedUndirectedGraph.new
    edges = []
    set = makeset(g.v)
    
    g.e.each do |edge|
      edges << Edge.new(set_find(set,edge.src), 
                        set_find(set,edge.dest), 
                        edge.weight) 
    end
    edges.sort!
    edges.each do |e|
      if !e.src.find.eql?(e.dest.find)
        mst.add_edge(e.src.payload, 
                     e.dest.payload, 
                     e.weight) 
        e.src.union(e.dest)
      end
    end

    return mst
  end
  
  def makeset(vertices)
    set = []
    vertices.each do |v|
      set << DisjointSet.new(v)
    end

    return set
  end
  
  def set_find(v_djs, vertex)
    v_djs.select{|v| v.payload.eql?(vertex)}.pop
  end
end
  

    
    
