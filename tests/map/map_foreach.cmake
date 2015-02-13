function(test)

  message("Test inconclusive")
  return()

  map()
    kv(a 1)
    kv(b 2)
    kv(c 3)
  end()
  ans(map)


  ref_new()
  ans(myref)
  map_foreach("${map}" "[](key val)ref_append({{myref}} {{key}} {{val}})")
  ref_get(${myref})
  ans(vals)

  assert(EQUALS ${vals} a 1 b 2 c 3)

  map_foreach("" "[]() ")

  


endfunction()