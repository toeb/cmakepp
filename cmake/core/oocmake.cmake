# returns a config value
function(oocmake key)

    if(${ARGN})
      set_property(GLOBAL PROPERTY "oocmake.${key}" "${ARGN}")
    endif()
    get_property(res GLOBAL PROPERTY "oocmake.${key}")
    set("${key}" "${res}" PARENT_SCOPE)
endfunction()