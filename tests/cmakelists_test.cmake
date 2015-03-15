function(test)

  function(cmakelists_open)
    map_new()
    ans(cmakelists)

    path("CMakeLists.txt")
    ans(cmakelists_path)
    if(NOT EXISTS "${cmakelists_path}")
      path_parent_dir_name("cmakelists_path}")
      ans(project_name)
      set(content "cmake_minimum_required(VERSION ${CMAKE_VERSION})\n\nproject(${project_name})")

    else()
      fread("${cmakelists_path}")
      ans(content)
    endif()



    cmake_tokens("${content}")
    ans(tokens)
    map_set(${cmakelists} tokens ${tokens})
    list_peek_front(tokens)
    ans(begin)
    list_peek_back(tokens)
    ans(end)
    map_set(${cmakelists} begin ${begin})
    map_set(${cmakelists} end ${end} )
    map_set(${cmakelists} path "${cmakelists_path}")
    
    return_ref(cmakelists)
  endfunction()


  function(cmakelists_close cmakelists) 
    map_tryget(${cmakelists} begin)
    ans(begin)
    cmake_token_range_serialize("${begin}")
    ans(content)
    map_tryget(${cmakelists} path)
    ans(cmakelists_path)
    fwrite("${cmakelists_path}" "${content}")
  endfunction()


  function(token_range_section_find range section_name)
    set(section_begin_comment "# <section name=\"${section_name}\"> ##")
    set(section_end_comment "# </section> ##")

    string_regex_escape("${section_begin_comment}")
    ans(section_begin_regex)
    
    string_regex_escape("${section_end_comment}")
    ans(section_end_regex)

    set(section_begin_regex "^${section_begin_regex}$")
    set(section_end_regex "^${section_end_regex}$")

    list_extract(range begin end)
    print_vars(begin end)
    cmake_token_range_find_next_by_type("${range}" "^line_comment$" "${section_begin_regex}")
    ans(section_begin_token)
    if(NOT section_begin_token)
      message(no begin)
      return()
    endif()
    
    cmake_token_range_find_next_by_type("${section_begin_token};${end}" "^line_comment$" "${section_end_regex}")
    ans(section_end_token)
    if(NOT section_end_token)
      message(no end)
      return()
    endif()
    map_tryget(${section_begin_token} next)
    ans(section_begin_token)
    map_tryget(${section_begin_token} next)
    ans(section_begin_token)
    return(${section_begin_token} ${section_end_token})
  endfunction()

  cmake_tokens("
asd()
## lolo
bsd()
  ## <section name=\"karlo\"> ##
    message(hello karlo)

dkdkdkd()
  
  ## </section> ##
  ## <section name=\"karlo2\"> ##

    message(hello karlo2)

    asdasd(asdasd)
    ## kakaka
  muuu()## </section> ##

    ")
  ans_extract(range)
  
  token_range_section_find("${range}" "karlo2")
  ans(section)
  print_vars(section)
  cmake_token_range_serialize("${section}")
  ans(res)

  _message("${res}")


  return()

  function(cmakelists_add_target cmakelists type name)
    if(NOT "${type}" MATCHES "^(library)|(executable)$")
      message(FATAL_ERROR "invalid target type: ${type}")
    endif()

    map_tryget(${cmakelists} begin)
    ans(begin)

    cmake_token_range_find_next_by_type("^line_comment$" "^# <section>${name}</section> ##$")
    ans(section_begin)
    
    if(section_begin) 
      message(FATAL_ERROR "the target already exists")
    endif()   


    cmake_token_range_find_next_by_type("^line_comment$" "^# <section>targets</section> ##$")



  endfunction()


  pushd(proj1 --create)
  
  cmakelists_open()
  ans(cmakelists)



  cmakelists_close(${cmakelists})



  popd()



endfunction()