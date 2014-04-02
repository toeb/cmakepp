function(test)

  set(lst1 0 1 2 3)
  set(lst2 3 2 1 0)
  set(lst3 0 0 0 0)
  set(lst4 0)
  set(lst5 )

  # peek front
  list_peek_front(res lst1)
  assert("${res}" STREQUAL "0")

  list_peek_front(res lst2)
  assert("${res}" STREQUAL "3")

  list_peek_front(res lst3)
  assert("${res}" STREQUAL "0")

  list_peek_front(res lst4)
  assert("${res}" STREQUAL "0")

  list_peek_front(res lst5)
  assert(NOT res)  


  # peek back
  list_peek_back(res lst1)
  assert("${res}" STREQUAL "3")

  list_peek_back(res lst2)
  assert("${res}" STREQUAL "0")

  list_peek_back(res lst3)
  assert("${res}" STREQUAL "0")

  list_peek_back(res lst4)
  assert("${res}" STREQUAL "0")

  list_peek_back(res lst5)
  assert(NOT res)  

  # pop front
  list_pop_front(res lst1)
  assert("${res}" STREQUAL 0)
  assert(EQUALS ${lst1} 1 2 3 )
 

  list_pop_front(res lst2)
  assert("${res}" STREQUAL 3)
  assert(EQUALS ${lst2} 2 1 0)

  list_pop_front(res lst3)
  assert("${res}" STREQUAL 0)
  assert(EQUALS ${lst3} 0 0 0  )


  list_pop_front(res lst3)
  assert("${res}" STREQUAL 0)
  assert(EQUALS ${lst3} 0 0  )

  list_pop_front(res lst3)
  assert("${res}" STREQUAL 0)
  assert(EQUALS ${lst3} 0  )

  list_pop_front(res lst3)
  assert("${res}" STREQUAL 0)
  assert(NOT lst3  )




  set(lst1 0 1 2 3)
  set(lst2 3 2 1 0)
  set(lst3 0 0 0 0)

  #pop back
  list_pop_back(res lst1)
  assert("${res}" STREQUAL 3)
  assert(EQUALS ${lst1} 0 1 2 )
 

  list_pop_back(res lst2)
  assert("${res}" STREQUAL 0)
  assert(EQUALS ${lst2} 3 2 1 )

  list_pop_back(res lst3)
  assert("${res}" STREQUAL 0)
  assert(EQUALS ${lst3} 0 0 0   )

  list_pop_back(res lst3)
  assert("${res}" STREQUAL 0)
  assert(EQUALS ${lst3} 0 0   )

  list_pop_back(res lst3)
  assert("${res}" STREQUAL 0)
  assert(EQUALS ${lst3}  0   )


  list_pop_back(res lst3)
  assert("${res}" STREQUAL 0)
  assert(NOT lst3 )


  



endfunction()