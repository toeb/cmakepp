function(test)

  json2("{\"asd\":\"he[]ll;o\", \"bsd\":[1,2,3,4]}")

  timer_start(t1)
  json2("{\"asd\":\"he[]ll;o\", \"bsd\":[1,2,3]}")
  ans(res)
  timer_print_elapsed(t1)


  timer_start(t1)
  json3("{\"a.sd\":\"he[]ll;o\", \"bs;d\":[1,[5,6],{ \"asd\":\"abc\" \"def\", \"gugugaga\":[true,false,1,null,1,null,\"lala\"] },3]}")
  ans(res)
  timer_print_elapsed(t1)
  timer_start(t1)
  json2("{\"a.sd\":\"he[]ll;o\", \"bs;d\":[1,[5,6],{ \"asd\":\"abc\" \"def\", \"gugugaga\":[true,false,1,null,1,null,\"lala\"] },3]}")
  ans(res)
  timer_print_elapsed(t1)



#  json_print(${res})

endfunction()