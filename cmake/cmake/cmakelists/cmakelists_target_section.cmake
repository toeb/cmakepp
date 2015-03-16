

function(cmakelists_target_section cmakelists target_name)
  set(args ${ARGN})

  map_tryget(${cmakelists} begin)
  ans(begin)

  cmake_token_range_comment_section_find("${begin}" "target:${target_name}")
  ans(target_section)
  if(NOT target_section)
    error("could not find section 'target:${target_name}'")
    return()
  endif()
  return_ref(target_section)
endfunction()
