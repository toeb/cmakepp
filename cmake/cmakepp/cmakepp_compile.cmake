
## cmakepp_compile() 
##
## compiles cmakepp into a single file which is faster to include
function(cmakepp_compile target_file)
  path_qualify(target_file)

  cmakepp_config(base_dir)
  ans(base_dir)

  file(STRINGS "${base_dir}/cmakepp.cmake" oocmake_file)

  foreach(line ${oocmake_file})
    if("_${line}" STREQUAL "_include(\"\${cmakepp_base_dir}/cmake/core/require.cmake\")")

    elseif("_${line}" STREQUAL "_require(\"\${cmakepp_base_dir}/cmake/*.cmake\")")

      file(GLOB_RECURSE files "${base_dir}/cmake/**.cmake")

      foreach(file ${files} ) 
        file(READ  "${file}" content)      
        file(APPEND "${target_file}" "\n\n\n${content}\n\n")
      endforeach()
    else()
      file(APPEND "${target_file}" "${line}\n")
  endif()
  endforeach()
endfunction()

