## `(<clauses:<sequence>> <dependee_handle:<package handle>> <dependency constraint> <possible_dependencies:{<package uri>:<package handle>}>)-><void>`
##
## * `clauses` sequence of cnf clauses 
## * `dependee_handle` a package handle which represents the dependee
## * `dependency_constraint` the cosntraint placed upond the dependencies
## * `possible_dependencies` a map containing all possible package handles of dependencies
##
##  adds all depdency clauses for dependee handle 
function(package_dependency_clauses_add 
  clauses 
  dependee_handle 
  dependency_constraint 
  possible_dependencies)

  ## get all package handles
  map_flatten(${possible_dependencies})
  ans(dependency_handles)

  map_tryget(${dependee_handle} uri)
  ans(dependee_uri)
  
  if("${dependency_constraint}_" STREQUAL "_") ## optional
    ## do nothing - optoinal dependency
    ## (dependee_uri | dependency_uri)
  elseif("${dependency_constraint}" STREQUAL "false")
    ## conflicting dependency
    ## (!dependee_uri | !dependency_uri) & (!dependee_uri | !dependency_uri) & ...
    foreach(dependency_handle ${dependency_handles})
      map_tryget(${dependency_handle} uri)
      ans(dependency_uri)
      sequence_add(${clauses} "!${dependee_uri}" "!${dependency_uri}")
      ans(ci)
    endforeach()
  
  elseif("${dependency_constraint}" STREQUAL "true")
    ## required dependency
    ## (!dependee_uri | dependency_uri1 | dependency_uri2 | ...)
    sequence_add(${clauses} "!${dependee_uri}")
    ans(ci)
    foreach(dependency_handle ${dependency_handles})
      map_tryget(${dependency_handle} uri)
      ans(dependency_uri)
      sequence_append("${clauses}" "${ci}" "${dependency_uri}")
    endforeach()

  else()
    ## complex dependency
    ## 
    if(NOT "${dependency_constraint}" MATCHES "^(true)|(false)$")
      message(FATAL_ERROR "complex dependency constraints not supported: '${dependency_constraint}'")
    endif()

  endif()

endfunction()