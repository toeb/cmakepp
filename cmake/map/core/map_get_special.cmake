
  function(map_get_special map key)
    map_tryget("${map}" "__${key}__")
    return_ans()
  endfunction()