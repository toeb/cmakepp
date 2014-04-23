
function(expr_indexer path)
  #message("indexer and stuff ${path}")
  string_nested_split("${path}" "["  "]")
  ans(parts)
 # message("parts ${parts}")
  list_get("parts" "-2")
  ans(indexer)
 # message("got indexer :${indexer}")
#return()
  string_remove_ending("${path}" "${indexer}")
  ans(path)

#  message("indexer ${indexer}")
  #message("${path}")

  expr("${path}")
  ans(data)

  string_slice("${indexer}" 1 -2)
  ans(index_expr)

  expr("${index_expr}")
  ans(index)

 # message("data: ${data}")
 # message("index_expr: ${index_expr}")
 # message("index :${index}")

  #integer indexation
  expr_integer_isvalid("${index}")
  ans(is_int)
  if(is_int)
    # expect data to be a list or a map
    map_isvalid("${data}" trash)
    ans(ismap)
    if(ismap)
      map_keys(${data} keys)
      list_get(keys "${index}")
      ans(key)
      map_get(${data} res ${key})
      return_ref(res)
    endif()
    ref_isvalid("${data}")
    ans(isref)
    if(isref)
      #deref ref
      ref_get(${data})
      ans(data)
    endif()
    # data is list
    list_get(data "${index}")
    return_ans()
  endif()

  # string indexation needs map
  map_isvalid("${data}" trash)
  ans(ismap)
  if(NOT ismap)
    return()
  endif()

  #return nothing if map does not have key
  map_has(${data} haskey "${index}")
  if(NOT haskey)
    return()
  endif()

  map_get(${data} result ${index} )
  return_ref(result)

endfunction()