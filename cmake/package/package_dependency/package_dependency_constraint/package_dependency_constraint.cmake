
function(package_dependency_constraint type package_handle)
  map_new()
  ans(constraint)
  map_set(${constraint} type "${type}")
  map_set(${constraint} package_handle "${package_handle}")
  return(${constraint})
endfunction()
