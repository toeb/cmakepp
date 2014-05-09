# iterates a the graph with root nodes in ${ARGN}
# in breadth first order
# expand must consider cycles
function(bfs expand)
  queue_new()
  ans(queue)
  curry(queue_push("${queue}" /1))
  ans(push)
  curry(queue_pop("${queue}"))
  ans(pop)
  graphsearch(EXPAND "${expand}" PUSH "${push}" POP "${pop}" ${ARGN})
endfunction()