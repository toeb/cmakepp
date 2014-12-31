function(test)



  define_test_function(test_uut range)
  
  test_uut("{begin:'*',end:'*',increment:'1',value:''}" "")
  test_uut("{begin:'1',end:'2',increment:'1',value:'1'}" "1")
  test_uut("{begin:'2',end:'3',increment:'1',value:'2:3'}" "2:3")
  test_uut("{begin:'2',end:'3',increment:'-3',value:'2:-3:3'}" "2:-3:3")
  test_uut("{begin:'-3',end:'-2',increment:'1',value:'-3:1:-2'}" "-3:-2")


  




endfunction()