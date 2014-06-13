
  function(map_set_special map key)
    map_set_hidden("${map}" "__${key}__" "${ARGN}")
  endfunction()