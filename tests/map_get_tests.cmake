function(Test)
  map_new()
    ans(a)
  map_set("${a}" "x" 0)
  map_get("${a}" res "x")
  assert("${res}" STREQUAL 0)

  map_set("${a}" "x" NOTFOUND)
  map_get("${a}" res "x")
  assert("${res}" STREQUAL NOTFOUND)

  map_set("${a}" "x" NO)
  map_get("${a}" res "x")
  assert("${res}" STREQUAL NO)


  return()

  nav("a.x" 0)
  map_get("${a}" res "${x}")
  assert("${res}" STREQUAL 0)
endfunction()