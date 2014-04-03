
  function(list_fold lst folder)
    if(NOT "_${ARGN}" STREQUAL _folding)
      import_function("${folder}" as __list_fold_folder REDEFINE)
    endif()
    set(rst ${${lst}})
    list_split_first(left rst rst )
    if(NOT DEFINED rst)
      return(${left})
    endif()


    list_fold(rst "" folding)
    ans(right)
    __list_fold_folder("${left}" "${right}")

    ans(res)

   # message("left ${left} right ${right} => ${res}")
    return(${res})
  endfunction()