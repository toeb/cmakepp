# returns the checksum for the specified object (object graph)
function(checksum_object obj)
  
  json("${obj}")
  ans(json)
  checksum_string("${json}" ${ARGN})
  return_ans()
endfunction()