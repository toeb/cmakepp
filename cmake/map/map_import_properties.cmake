## imports the specified properties into the current scope
## e.g map = {a:1,b:2,c:3}
## map_import_properties(${map} a c)
## -> ${a} == 1 ${b} == 2
  function(map_import_properties map)
    foreach(key ${ARGN})
      map_tryget("${map}" "${key}")
      ans(value)
      set(${key} ${value} PARENT_SCOPE)
    endforeach()
    return()
  endfunction()

