function(test)


  function(cmakelists_open)
    map_new()
    ans(cmakelists)

    pushd("${ARGN}")

    path("CMakeLists.txt")
    ans(cmakelists_path)
    if(NOT EXISTS "${cmakelists_path}")
      path_parent_dir_name("cmakelists_path}")
      ans(project_name)
      set(content "cmake_minimum_required(VERSION ${CMAKE_VERSION})\n\nproject(${project_name})\n## <section name=\"targets\">\n## </section>\n")

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
    popd()
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



    cmake_token_range_replace("${targets_section}" 
"##   <section name=\"target:${name}\">
set(sources)
set(link_libraries)
set(include_directories)
add_${type}(${name} \${sources})
target_link_libraries(${name} \${link_libraries})
target_include_directories(${name} \${include_directories})
##   </section>
")

  endfunction()

  function(cmakelists_target_add_source_files cmakelists target_name)
    map_tryget(${cmakelists} begin)
    ans(begin)

    cmake_token_range_comment_section_find("${begin}" "target:${target_name}")
    ans(target_section)
    if(NOT target_section)
      error("could not find section 'target:${target_name}'")
      return()
    endif()
    map_tryget(${cmakelists} path)
    ans(path)
    pushd("${path}" --force)
    foreach(file ${ARGN})
      path_qualify(file)
      if(NOT EXISTS "${file}")
        fwrite("${file}" "")
      endif()
    endforeach()

    cmake_invocation_argument_list_find("${target_section}" "^set$"  "^source($|;)")
    ans(variable_invocation)


    print_vars(variable_invocation)

    #cmake_invocation_get_arguments_list()
    #cmake_invocation_set_arguments()

    popd()

  endfunction()


  pushd(proj1 --create)
  
  cmakelists_open()
  ans(cmakelists)


  cmakelists_add_target(${cmakelists} library my_lib)

  cmakelists_target_add_source_files("${cmakelists}" "my_lib" "hihi.cpp" "huhu.h")

  cmakelists_close(${cmakelists})



  popd()



endfunction()