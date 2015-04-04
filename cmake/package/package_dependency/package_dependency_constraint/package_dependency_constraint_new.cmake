## `(<type:<string>> <package handle>)-> <package dependency constraint>` 
##
## creates a new dependecy constraint.  The type must be unqiue.
function(package_dependency_constraint_new type package_handle)
  map_new()
  ans(constraint)
  map_set(${constraint} type "${type}")
  map_set(${constraint} package_handle "${package_handle}")
  return(${constraint})
endfunction()
