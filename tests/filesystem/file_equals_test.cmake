function(test)


  # arrange
  fwrite("a.txt" "abc")
  fwrite("b.txt" "cde") 
  fwrite("c.txt" "cde") 



  file_equals("a.txt" "b.txt")
  ans(res)
  assert(NOT res)


  file_equals("a.txt" "a.txt")
  ans(res)
  assert(res)

  file_equals("b.txt" "c.txt")
  ans(res)
  assert(res)

endfunction()