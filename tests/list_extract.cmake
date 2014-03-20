function(test)

  set(val5)
 set(thelist a b c d)
 list_extract(thelist val1 val2 val3 val4 val5)

 assert(${val1} STREQUAL a)
 assert(${val2} STREQUAL b)
 assert(${val3} STREQUAL c)
 assert(${val4} STREQUAL d)
 assert(NOT val5)

endfunction()