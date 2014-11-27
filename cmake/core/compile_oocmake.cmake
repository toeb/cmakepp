

  function(compile_oocmake source_dir target)



    set(base_dir ${source_dir})

    file(READ "${base_dir}/resources/expr.json" data)
    get_filename_component(res "${target}" "PATH")

    file(WRITE "${res}/resources/expr.json" "${data}")


    file(STRINGS "${base_dir}/oo-cmake.cmake" oocmake_file)


    foreach(line ${oocmake_file})
      if("_${line}" STREQUAL "_include(\"\${oocmake_base_dir}/cmake/core/require.cmake\")")

      elseif("_${line}" STREQUAL "_require(\"\${oocmake_base_dir}/cmake/*.cmake\")")

        file(GLOB_RECURSE files "${base_dir}/cmake/**.cmake")



        foreach(file ${files} ) 
          file(READ  "${file}" content)      
          file(APPEND "${target}" "\n\n\n${content}\n\n")
        endforeach()


      else()
      
        file(APPEND "${target}" "${line}\n")
    endif()
    endforeach()






  endfunction()