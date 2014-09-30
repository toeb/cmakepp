# folds the specified list into a single result by recursively applying the aggregator
function(list_fold lst aggregator)
  if(NOT "_${ARGN}" STREQUAL _folding)
    function_import("${aggregator}" as __list_fold_folder REDEFINE)
  endif()
  set(rst ${${lst}})
  list_pop_front(rst)
  ans(left)
  
  if("${rst}_" STREQUAL "_")
    return(${left})
  endif()


  list_fold(rst "" folding)
  ans(right)
  __list_fold_folder("${left}" "${right}")

  ans(res)

 # message("left ${left} right ${right} => ${res}")
  return(${res})
endfunction()