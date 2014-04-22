
  function(require file)
    require_map()
    ans(require_map)
    map_get(${require_map} stack include_dirs)
    message("stack is ${stack}")
    stack_peek(${stack})
    ans(include_dirs)
    message("include dirs are ${include_dirs}")

    get_filename_component(extension "${file}" EXT)
    if(NOT extension)
      set(file "${file}.cmake")
    endif()

    file_find("${file}" ${include_dirs})
    ans(result_file)

    if(NOT result_file)
      message(FATAL_ERROR "could not find file '${file}'")
    endif()

    map_tryget(${require_map} trash ${result_file})
    ans(was_included)
    if(was_included)
      return()
    endif()

    get_filename_component(directory  "${result_file}" PATH)
    stack_push(${stack} ${include_dirs} ${directory})
    include(${result_file})
    map_set(${require_map} "${result_file}" true)

    return_ref(result_file)
  endfunction()
  