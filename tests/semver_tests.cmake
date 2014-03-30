function(test)

  #semver_constraint_evaluate(res "0.0.1 0.0.2" "")

  semver_constraint_evaluate(res  "=0.0.1" "0.0.1") 
  assert(res)
  semver_constraint_evaluate(res  "=0.0.1" "0.0.2") 
  assert(NOT res)
  semver_constraint_evaluate(res  "!0.0.1" "0.0.1") 
  assert(NOT res)
  semver_constraint_evaluate(res  "!0.0.1" "0.0.2") 
  assert(res)
  semver_constraint_evaluate(res  ">0.0.1" "0.0.2") 
  assert(res)
  semver_constraint_evaluate(res  ">0.0.1" "0.0.1") 
  assert(NOT res)
  semver_constraint_evaluate(res  "<0.0.1" "0.0.0") 
  assert(res)
  semver_constraint_evaluate(res  "<0.0.1" "0.0.1") 
  assert(NOT res)


  semver_normalize(res "1")
  assert("${res}" STREQUAL "1.0.0")

  semver_normalize(res "")
  assert("${res}" STREQUAL "0.0.0")

  semver_normalize(res "1.0")
  assert("${res}" STREQUAL "1.0.0")
    
  semver_constraint_evaluate_element(res "=2.0.0" "2.0.0")
  assert(res)
  semver_constraint_evaluate_element(res "=2" "2.0.0")
  assert(res)
  semver_constraint_evaluate_element(res "=2.0" "2.0.0")
  assert(res)
  semver_constraint_evaluate_element(res "2" "2.0.0")
  assert(res)
  semver_constraint_evaluate_element(res "2" "2.0.1")
  assert(NOT res)


  semver_constraint_evaluate_element(res "!2.0" "2.0.0")
  assert(NOT res)
  semver_constraint_evaluate_element(res "!2.0" "2.0.0-alpha")
  assert( res)

  semver_constraint_evaluate_element(res ">2" "2.0.1")
  assert(res)
  semver_constraint_evaluate_element(res ">2" "2.0.0")
  assert(NOT res)

  semver_constraint_evaluate_element(res ">=2" "2.0.1")
  assert(res)
  semver_constraint_evaluate_element(res ">=2" "2.0.0")
  assert(res)
  semver_constraint_evaluate_element(res ">=2" "1.0.0")
  assert(NOT res)


  semver_constraint_evaluate_element(res "<2" "1.9.9")
  assert(res)
  semver_constraint_evaluate_element(res "<2" "2.0.0")
  assert(NOT res)


  semver_constraint_evaluate_element(res "<=2" "1.9.9")
  assert(res)
  semver_constraint_evaluate_element(res "<=2" "2.0.0")
  assert( res)
  semver_constraint_evaluate_element(res "<=2" "2.0.1")
  assert(NOT res)

  semver_constraint_evaluate_element(res "~2.3.4" "2.0.1")
  assert(NOT res)

  semver_constraint_evaluate_element(res "~2.3.4" "2.3.4")
  assert(res)

  semver_constraint_evaluate_element(res "~2.3" "2.3.4")
  assert(res)

  semver_constraint_evaluate_element(res "~2.3" "2.4.4")
  assert(NOT res)


  semver_constraint_evaluate_element(res "~2" "2.3.4")
  assert(res)
  semver_constraint_evaluate_element(res "~2" "3.0.0")
  assert(NOT res)
  semver_constraint_evaluate_element(res "~2" "2.0.0")
  assert(res)
  semver_constraint_evaluate_element(res "~2" "1.9.9")
  assert(NOT res)



  semver_constraint_evaluate(res "<=3,>2" "3.0.0")
  assert(res)
  semver_constraint_evaluate(res "<=3,>=2" "2.0.0")
  assert(res)




   semver_parse("0.331.21-alpha.dadad.23.123.asd+lolo.23.asd" MAJOR major MINOR minor PATCH patch PRERELEASE pre METADATA meta RESULT res IS_VALID isvalid VERSION ver VERSION_NUMBERS vernum)
   assert(EQUALS ${major} 0)
   assert(EQUALS ${minor} 331)
   assert(EQUALS ${patch} 21)
   assert(EQUALS ${pre} alpha dadad 23 123 asd)
   assert(EQUALS ${meta} lolo 23 asd)
   assert(EQUALS ${isvalid} true)
   assert(EQUALS ${ver} 0.331.21-alpha.dadad.23.123.asd)
   assert(EQUALS ${vernum} 0.331.21)

   semver_parse("0" MAJOR major MINOR minor PATCH patch PRERELEASE pre METADATA meta RESULT res IS_VALID isvalid VERSION ver VERSION_NUMBERS vernum)
   assert(NOT isvalid)

   semver_parse("0.1" MAJOR major MINOR minor PATCH patch PRERELEASE pre METADATA meta RESULT res IS_VALID isvalid VERSION ver VERSION_NUMBERS vernum)
   assert(NOT isvalid)


   semver_parse("0.1.1" MAJOR major MINOR minor PATCH patch PRERELEASE pre METADATA meta RESULT res IS_VALID isvalid VERSION ver VERSION_NUMBERS vernum)
   assert(isvalid)


   semver_parse("0.331.21" MAJOR major MINOR minor PATCH patch PRERELEASE pre METADATA meta RESULT res IS_VALID isvalid VERSION ver VERSION_NUMBERS vernum)
   assert(EQUALS ${major} 0)
   assert(EQUALS ${minor} 331)
   assert(EQUALS ${patch} 21)
   assert(EQUALS ${isvalid} true)
   assert(EQUALS ${ver} 0.331.21)
   assert(EQUALS ${vernum} 0.331.21)



  semver_component_compare(res "" "")
  assert(${res} EQUAL 0)
  semver_component_compare(res "a" "")
  assert(${res} EQUAL -1)
  semver_component_compare(res "" "a")
  assert(${res} EQUAL 1)

  semver_component_compare(res 0 1)
  assert(${res} EQUAL 1)
  semver_component_compare(res 1 2)
  assert(${res} EQUAL 1)
  semver_component_compare(res 2 1)
  assert(${res} EQUAL -1)
  semver_component_compare(res 1 1)
  assert(${res} EQUAL 0)


  semver_component_compare(res a 1)
  assert(${res} EQUAL -1)
  semver_component_compare(res 1 a)
  assert(${res} EQUAL 1)
  semver_component_compare(res a a)
  assert(${res} EQUAL 0)
  semver_component_compare(res a b)
  assert(${res} EQUAL 1)
  semver_component_compare(res b a)
  assert(${res} EQUAL -1)
 





  semver_compare(semver_compare "1.0.0" "2.0.0")
  assert(${semver_compare} EQUAL 1)
  semver_compare(semver_compare "2.0.0" "2.1.0")
  assert(${semver_compare} EQUAL 1)
  semver_compare(semver_compare "2.1.0" "2.1.1")
  assert(${semver_compare} EQUAL 1)
  semver_compare(semver_compare "1.0.0-alpha" "1.0.0")
  assert(${semver_compare} EQUAL 1)
  semver_compare(semver_compare "1.0.0-alpha" "1.0.0")
  assert(${semver_compare} EQUAL 1)
  semver_compare(semver_compare "1.0.0-alpha" "1.0.0-alpha.1")
  assert(${semver_compare} EQUAL 1)
  semver_compare(semver_compare "1.0.0-alpha.1" "1.0.0-alpha.beta")
  assert(${semver_compare} EQUAL 1)
  semver_compare(semver_compare "1.0.0-alpha.beta" "1.0.0-beta")
  assert(${semver_compare} EQUAL 1)
  semver_compare(semver_compare "1.0.0-beta" "1.0.0-beta.2")
  assert(${semver_compare} EQUAL 1)
  semver_compare(semver_compare "1.0.0-beta.2" "1.0.0-beta.11")
  assert(${semver_compare} EQUAL 1)
  semver_compare(semver_compare "1.0.0-beta.11" "1.0.0-rc.1")
  assert(${semver_compare} EQUAL 1)
  semver_compare(semver_compare "1.0.0-rc.1" "1.0.0")
  assert(${semver_compare} EQUAL 1)













endfunction()