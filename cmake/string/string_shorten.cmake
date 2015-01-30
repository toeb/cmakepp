
## shortens the string to be at most max_length long
  function(string_shorten str max_length)
    set(shortener "${ARGN}")
    if(shortener STREQUAL "")
      set(shortener "...")
    endif()

    string(LENGTH "${str}" str_len)
    string(LENGTH shortener shortener_len)
    math(EXPR combined_len "${str_len} + ${shortener_len}")

    if(NOT str_len GREATER "${max_length}")
      return_ref(str)
    endif()

    math(EXPR max_length "${max_length} - ${shortener_len}")

    string_slice("${str}" 0 ${max_length})
    ans(res)
    set(res "${res}${shortener}")
    return_ref(res)
  endfunction()

