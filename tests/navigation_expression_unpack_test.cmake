function(test)



  

  set(uut)
  navigation_expression_unpack(uut)
  assert(${uut.property} ISNULL)
  assert(${uut.is_range} EQUALS false)
  assert(${uut.is_property} EQUALS true)
  assert(${uut.range} EQUALS "0:*")
  assert(${uut.range.increment} EQUALS 1)
  assert(${uut.range.begin} EQUALS 0)
  assert(${uut.range.end} EQUALS *)

  set(uut prop)
  navigation_expression_unpack(uut)
  assert(${uut.property} EQUALS prop)
  assert(${uut.is_range} EQUALS false)
  assert(${uut.is_property} EQUALS true)
  assert(${uut.range} EQUALS "0:*")
  assert(${uut.range.increment} EQUALS 1)
  assert(${uut.range.begin} EQUALS 0)
  assert(${uut.range.end} EQUALS *)

  set(uut [6])
  navigation_expression_unpack(uut)
  assert(${uut.property} ISNULL)
  assert(${uut.is_range} EQUALS true)
  assert(${uut.is_property} EQUALS false)
  assert(${uut.range} EQUALS "6")
  assert(${uut.range.increment} EQUALS 1)
  assert(${uut.range.begin} EQUALS 6)
  assert(${uut.range.end} EQUALS 7)



endfunction()