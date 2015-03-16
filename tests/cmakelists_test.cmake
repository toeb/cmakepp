function(test)

  macro(cmake_token_go_back token_ref)
    map_tryget(${${token_ref}} previous)
    ans(${token_ref})
  endmacro()



  function(cmakelists_targets cmakelists) 
    set(regex_section_begin "^[# ]*<section[ ]+name[ ]*=[ ]*\"([^\"]+)\"[ ]*>[ #]*$")

    regex_cmake()
    map_tryget(${cmakelists} begin)
    ans(begin)

    cmake_token_range_comment_section_find_all("${begin}" "target:${regex_cmake_identifier}")
    ans(sections)

    while(sections)
      list_extract(sections target_begin target_end)
      ans(sections)
      set(section_header_token ${target_begin})
      cmake_token_go_back(section_header_token) # \n
      cmake_token_go_back(section_header_token) # header commment

      map_tryget(${section_header_token} literal_value)
      ans(section_header)

      if("${section_header}" MATCHES "${regex_section_begin}")
        if("${CMAKE_MATCH_1}" MATCHES "^target:(.*)$")
          set(target_name "${CMAKE_MATCH_1}")
        endif()
      endif()
    
      if(NOT target_name)
        message(FATAL_ERROR "could not extract target name from section")
      endif()

      cmake_token_range_invocations_filter("${targt_begin};${target_end}"  --take 1)
      ans(target_invocation)
      
      map_capture_new(taget_name)      

    endwhile()


  endfunction()



  pushd(proj1 --create)
  
  cmakelists_open()
  ans(cmakelists)


  cmakelists_add_target(${cmakelists} library my_lib)
  cmakelists_add_target(${cmakelists} library my_lib2)
  cmakelists_add_target(${cmakelists} executable my_lib3)

  cmakelists_target_add_source_files("${cmakelists}" "my_lib" "hihi.cpp" "huhu.h" --append)
  cmakelists_target_add_source_files("${cmakelists}" "my_lib" "gaga.cpp" "blublu.h" --append)
  pushd(dir1 --create)
    cmakelists_target_add_source_files("${cmakelists}" "my_lib" "gaganana.cpp" "blublsssu.h" --append)
    cmakelists_target_add_source_files("${cmakelists}" "my_lib" "gagaasdasd.cpp" "blubludd.h" --append)
  popd()
  cmakelists_target_add_source_files("${cmakelists}" "my_lib" --sort)


  cmakelists_targets(${cmakelists})
  ans(res)

  cmakelists_close(${cmakelists})


  popd()



endfunction()