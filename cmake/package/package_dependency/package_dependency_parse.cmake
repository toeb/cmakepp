## `()->`
## 
## parses a package dependency from a string 
## the string must at least contain the uri of the package
## returns null if package is invalid
function(package_dependency_parse)
  set(args ${ARGN})

  list_extract_labelled_value(args --content-dir)
  ans(content_dir)

  list_extract_flag(args --optional)
  ans(is_optional)

  list_extract_flag(args --dev)
  ans(is_dev)

  list_pop_front(args)
  ans(uri)


  if("${uri}_" STREQUAL "_")
    return()
  endif()


  map_new()
  ans(result)


  map_set(${result} uri ${uri})

  if(is_optional)
    map_set(${result} optional true)
  endif()
  if(is_dev)
    map_set(${result} dev true)
  endif()
  if(content_dir)
    map_set(${result} content_dir ${content_dir})
  endif()
  return_ref(result)
endfunction()


