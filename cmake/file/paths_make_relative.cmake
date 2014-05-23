# makes all paths passed as varargs into paths relative to base_dir
function(paths_make_relative base_dir)
  set(res)
  get_filename_component(base_dir "${base_dir}" REALPATH)

  foreach(path ${ARGN})
    get_filename_component(path "${path}" REALPATH)
    file(RELATIVE_PATH path "${base_dir}" "${path}")
    list(APPEND res "${path}")
  endforeach()

  return_ref(res)
endfunction()