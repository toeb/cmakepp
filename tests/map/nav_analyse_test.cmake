function(test)




  function(test_func_obj input what)
    print_vars(input what)
    obj("${input}")
    ans(map)
    if(NOT map)
      set(map ${input})
    endif()
    nav_analyze("${map}" "${what}" ${ARGN})
    return_ans()
  endfunction()

  define_test_function(test_uut test_func_obj input what)


  # # current_path

   test_uut("a" "{a:123}" current_path a)
   test_uut("" "{b:123}" current_path a)
   test_uut("" "" current_path a)
   test_uut("" "123" current_path a)

   # current value
   test_uut("123" "123" current_value)
   test_uut("123" "abc;123;456" current_value "[1]")
   test_uut("456;123" "abc;123;456" current_value "[2,1]")
  
   test_uut("123" "{a:123}" current_value "a")
   test_uut("123" "{a:{b:123}}" current_value "a.b")
   test_uut("" "{a:123}" current_value "b")
   test_uut("" "{a:123}" current_value "a.b")


   test_uut("123" "{a:123}" current_value "a[0]")
   test_uut("123" "{a:123}" current_value "a[:]")
   test_uut("123;345" "{a:[123,345]}" current_value "a[:]")

   test_uut("123" "{a:[234,{a:123},456]}" current_value "a.[1].a")
   test_uut("" "{a:[234,{a:123},456]}" current_value "a.[2].a")
   test_uut("123" "{a:[234,{a:[567,{a:123},789]},456]}" current_value "a[1].a[1].a")

   test_uut("123" "abc;456;234;poi;123;867" current_value "[:][$:2:-1][1]") 


   # last property
   test_uut("" "123" last_property)
   test_uut("a" "{a:123}" last_property a)
   test_uut("" "{a:123}" last_property [0])


   # last_existing_property
   test_uut("" "123" last_existing_property a)
   test_uut("a" "{a:123}" last_existing_property a)
   test_uut("a" "{a:123}" last_existing_property "a.b")
   test_uut("b" "{a:{b:123}}" last_existing_property "a.b")
   test_uut("b" "{a:[456,{b:123},678]}" last_existing_property "a[1].b")

   # last_existing_ref
   test_uut("{b:123}" "{a:{b:123}}" last_existing_property_ref "a.b")
   test_uut("{b:123}" "{a:[456,{b:123},678]}" last_existing_property_ref  "a[1].b")






  # last_value_ranges
 # test_uut("[1]" "{a:{b:[345,123]}}" last_value_ranges "a.b[1]")
 # test_uut("[1];[0]" "{a:{b:[345,123]}}" last_value_ranges "a.b[1][0]")
 # test_uut("[1:0:-1];[1];[0]" "123;456" last_value_ranges "[1:0:-1][1][0]")



  # # current_length
  test_uut(5 "1;2;3;4;5" current_length)
  test_uut(4 "{a:[4,3,2,1]}" current_length a)









endfunction()