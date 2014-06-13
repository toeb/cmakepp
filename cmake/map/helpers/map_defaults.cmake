
# sets all undefined properties of map to the default value
function(map_defaults map defaults)
  obj("${defaults}")
  ans(defaults)

  map_keys("${map}")
  ans(keys)

  map_keys("${defaults}")
  ans(default_keys)

  list(REMOVE_ITEM default_keys ${keys})
  foreach(key "${default_keys}")
    map_tryget("${defaults}" "${key}")
    ans(val)
    map_set("${map}" "${key}" "${val}")
  endforeach()
  return_ref(map)
endfunction()