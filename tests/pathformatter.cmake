function(test)

  function(path_format path vars)
    obj("${vars}")
    ans(vars)
    map_import("${vars}")

    map_format("${vars}" "${path}")
    ans(path)
    path("${path}")
    return_ans()
  endfunction()

  function(path_unformat base_path path vars)

  endfunction()


endfunction()