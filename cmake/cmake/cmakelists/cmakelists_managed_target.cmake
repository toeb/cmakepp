
  
  function(cmakelists_managed_target cmakelists target_descriptor)

    map_tryget(${cmakelists} begin) 
    ans(begin)

    map_tryget(${target_descriptor} target_name)
    ans(target_name)

    cmake_token_range_comment_section_navigate("${begin}" "target.${target_name}")
    ans(target_section)
    if(NOT target_section)
      error("no managed target section found for {target_name}")
      return(false)
    endif() 

    cmake_token_range_variable("${target_section}" sources)
    ans(sources)
    cmake_token_range_variable("${target_section}" link_libraries)
    ans(link_libraries)
    cmake_token_range_variable("${target_section}" include_directories)
    ans(include_directories)

    map_capture(${target_descriptor} sources link_libraries include_directories)


    return(true)
  endfunction()