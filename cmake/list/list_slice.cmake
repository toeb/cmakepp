# retruns a portion of lst.
# negative indices count from back of list 
#
function(list_slice lst start_index end_index)
  # indices equal => select nothing

  list_normalize_index(${lst} ${start_index})
  ans(start_index)
  list_normalize_index(${lst} ${end_index})
  ans(end_index)

  if(${start_index} LESS 0)
    message(FATAL_ERROR "list_slice: invalid start_index ")
  endif()
  if(${end_index} LESS 0)
    message(FATAL_ERROR "list_slice: invalid end_index")
  endif()
  # copy array
  set(res)
  index_range(${start_index} ${end_index})
  ans(indices)
  foreach(idx ${indices})
    list(GET ${lst} ${idx} value)
    list(APPEND res ${value})
   # message("getting value at ${idx} from ${${lst}} : ${value}")
  endforeach()
 # message("${start_index} - ${end_index} : ${indices} : ${res}" )
  return_ref(res)
endfunction()