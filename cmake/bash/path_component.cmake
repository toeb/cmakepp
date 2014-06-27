
    function(path_component path path_component)
      get_filename_component(res "${path}" "${path_component}")
      return_ref(res)
    endfunction()