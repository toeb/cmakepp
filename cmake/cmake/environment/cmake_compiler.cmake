## 
## 
function(cmake_compiler language)
  set(id "${CMAKE_${language}_COMPILER_ID}")
  string_tolower("${id}")
  ans(id)
  #set(path "${CMAKE_${language}_COMPILER}")
  # path should not be returned as it is absolute
  set(version "${CMAKE_${language}_COMPILER_VERSION}")  
  set(major_version)
  set(minor_version)
  if("${version}" MATCHES "([0-9]+).([0-9]+)?")
    set(major_version "${CMAKE_MATCH_1}")
    set(minor_version "${CMAKE_MATCH_2}")
  endif()
  ## should not be used
 ## set(flags "${CMAKE_${language}_FLAGS}")
  set(abi "${CMAKE_${language}_ABI}")
  set(target "${CMAKE_${language}_TARGET}")
  set(launcher "${CMAKE_${language}_LAUNCHER}")
  map_capture_new(id path version major_version minor_version flags abi target launcher)
  return_ans()
endfunction()