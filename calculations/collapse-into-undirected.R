library(igraph)

g = read_graph("complement-converted-to-numbers", format = c("edgelist"))

h = as.undirected(g,
  mode = c("collapse"),
  edge.attr.comb = igraph_opt("edge.attr.comb")
)

write_graph(h, "complement-converted-to-numbers-undirected", format = c("edgelist"))
q()

#
# All thanks to Gabor Csardi
#
