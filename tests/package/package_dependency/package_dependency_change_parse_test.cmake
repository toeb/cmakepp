
function(test)
  define_test_function(test_uut package_dependency_change_parse)
  test_uut("")
  test_uut("A;add" "A")
  test_uut("A;add" "A add")
  test_uut("A;remove" "A remove")
  test_uut("A;optional" "A optional")
  test_uut("['A','add',{asd:1}]" "A {asd:1}")
  test_uut("A;conflict" "A conflict")

endfunction()