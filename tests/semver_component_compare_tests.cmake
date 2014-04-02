function(test)


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

  semver_component_compare(res 1 11)
  assert(${res} EQUAL 1)

  semver_component_compare(res 2 11)
  assert(${res} EQUAL 1)


  semver_component_compare(res alpha rc1)
  assert(${res} EQUAL 1)

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

endfunction()