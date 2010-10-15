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
#
# @author Sunil Pedapudi
# @date 10152010
require 'weighteddirectedgraph'

class WeightedUndirectedGraph < WeightedDirectedGraph
  def add_edge(src, dest, weight)
    super(src, dest, weight)
    super(dest, src, weight)
  end
end
