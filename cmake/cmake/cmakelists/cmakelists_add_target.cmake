
function(cmakelists_add_target cmakelists type name)
  if(NOT "${type}" MATCHES "^(library)|(executable)$")
    message(FATAL_ERROR "invalid target type: ${type}")
  endif()

  map_tryget(${cmakelists} begin)
  ans(begin)

  cmake_token_range_comment_section_find("${begin}" "target:${name}")
  ans(target_section)

  if(target_section)
    error("section already exists target:${name}")
    return()
  endif()

  cmake_token_range_comment_section_find("${begin}" "targets")
  ans(targets_section)

  if(NOT targets_section)
    error("no targets section exists in cmake file")
    return()
  endif()

  list_extract(targets_section section_begin section_end)
  map_tryget(${section_end} previous)
  ans(insertion_point)

  cmake_token_range_replace("${insertion_point};${section_end}" 
"
##   <section name=\"target:${name}\">
set(sources)
set(link_libraries)
set(include_directories)
add_${type}(${name} \${sources})
target_link_libraries(${name} \${link_libraries})
target_include_directories(${name} \${include_directories})
##   </section>

")

endfunction()