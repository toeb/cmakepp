function(test)


  map_match_obj("" "")
  ans(res)
  assert(res)



  map_match_obj("{}" "{}")
  ans(res)
  assert(res)


  map_match_obj("{a:1,b:2,c:3}" "{a:1,b:2,c:3}")
  ans(res)
  assert(res)


  map_match_obj("{a:1,b:2,c:3}" "{a:1}")
  ans(res)
  assert(res)

  map_match_obj("{a:{aa:1,ab:2},b:{ba:{baa:1}},c:3,d:4}"
    "{a:{aa:1},b:{ba:{baa:1}},c:3}"
    )
  ans(res)
  assert(res)


endfunction()