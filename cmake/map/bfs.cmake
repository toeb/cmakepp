# iterates a the graph with root nodes in ${ARGN}
# in breadth first order
# expand must consider cycles
function(bfs expand)
  queue_new()
  ans(queue)
  curry3(() => queue_push("${queue}" /0))
  ans(push)
  curry3(() => queue_pop("${queue}"))
  ans(pop)
  graphsearch(EXPAND "${expand}" PUSH "${push}" POP "${pop}" ${ARGN})
endfunction()