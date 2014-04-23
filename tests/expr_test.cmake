function(test)

  #language("${package_dir}/resources/json-language.json")
  language("${package_dir}/resources/expr.json")
  ans("lang")
  message("${lang}:'${package_dir}/resources/expr.json'")
  ref_print(${lang})


  # statements
  oocmake("$test1 = 'asd'; $test2='bsd'")

  ans(res)
  assert("${res}" STREQUAL "bsd")
  assert(test1)
  assert("${test1}" STREQUAL "asd")
  assert(test2)
  assert("${test2}" STREQUAL "bsd")

  # null coalescing
  set(someMap)
  oocmake("$someMap = $someMap ?? {a:123}")
  ans(res1)
  oocmake("$someMap = $someMap ?? {a:234}")
  ans(res2)
  map_isvalid(${res1} ismap)
  assert(ismap)
  assert("${res1}" STREQUAL "${res2}")
  assert(DEREF "{res2.a}" STREQUAL "123")

  # parenthesesed assignment
  oocmake("$res = ($b = {}).a = 'ad'")
  assert("${res}" STREQUAL "ad")
  assert(DEREF "{b.a}" STREQUAL "ad")

  # assign bound value
  map_new()
    ans(someMap)
  oocmake("$someMap.value1 = 123")
  ans(res)
  assert(${res} STREQUAL "123")
  assert(DEREF "{someMap.value1}" STREQUAL 123) 
  


  # assign indexer
  map_new()
    ans(this)
  oocmake("['testvalue'] = 33")
  ans(res)
  assert("${res}" STREQUAL "33")
  assert(DEREF "{this.testvalue}" STREQUAL 33)

  # chain multiple assign
  map_new()
    ans(this)
  oocmake("asd = bsd = csd = 3")
  ans(res)
  assert("${res}" STREQUAL 3)
  assert(DEREF "{this.asd}" STREQUAL "3")
  assert(DEREF "{this.bsd}" STREQUAL "3")
  assert(DEREF "{this.csd}" STREQUAL "3")
  # assignment of cmake var
  set(ast)
  oocmake("$asd='ad'")
  ans(res)
  assert("${res}" STREQUAL "ad")
  assert(asd)
  assert("${asd}" STREQUAL "ad")

  # assignment of scope variable
  map_new()
  ans(this)
  oocmake("bsd = 'hula'")
  ans(res)
  assert(${res} STREQUAL "hula")
  assert(DEREF "{this.bsd}" STREQUAL "hula")


  # complicated sample
  oocmake("{a:{b:{c:'()->return($this)',d:'hello'}}}.a.b.c().d")
  ans(res)
  assert("${res}" STREQUAL "hello")

  # object
  oocmake("{}")
  ans(res)
  map_isvalid(${res} ismap)
  assert(ismap)


  # object with value
  oocmake("{asd:312}")
  ans(res)
  map_isvalid(${res} ismap)
  assert(ismap)
  assert(DEREF "{res.asd}" STREQUAL "312")

  #object with multiple values
  oocmake("{asd:'asd', bsd:'bsd', csd:{a:1,b:2}}")
  
  ans(res)
  assert(DEREF "{res.asd}" STREQUAL "asd")
  assert(DEREF "{res.bsd}" STREQUAL "bsd")
  assert(DEREF "{res.csd.a}" STREQUAL "1")
  assert(DEREF "{res.csd.b}" STREQUAL "2")

  # list
  oocmake("[1,2,'abc']")
  ans(res)
  assert(EQUALS ${res} 1 2 "abc")

  # string
  oocmake("'312'")
  ans(res)
  assert("${res}" STREQUAL "312")

  # number
  oocmake("41414")
  ans(res)
  assert("${res}" EQUAL 41414)

  # cmake identifier
  set(cmake_var abcd)
  oocmake("$cmake_var")
  ans(res)
  assert("${res}" STREQUAL "abcd")

  # scope identifier
  map_new()
  ans(this)
  map_set(${this} identifier "1234")
  oocmake("identifier")
  ans(res)
  assert("${res}" STREQUAL "1234")

  # bind 
  map_new()
  ans(this)
  map_new()
  ans(next)
  map_set(${this} a ${next})
  map_set(${next} b "9876")
  oocmake("a.b")
  ans(res)
  assert("${res}" STREQUAL "9876")

  # call
  set(callable "(a b)->return('$a$b')")
  oocmake("$callable(1,2)")
  ans(res)
  assert("${res}" STREQUAL "12")

  # indexation
  map_new()
  ans(a)
  map_set(${a} a 1234)
  oocmake("$a['a']")
  ans(res)
  assert("${res}" STREQUAL "1234")




endfunction()