
  function(listing_append listing line)
    string_combine(" " ${ARGN})
    ans(rest)
    string_semicolon_encode("${line}${rest}")
    ans(line)
    ref_append("${listing}" "${line}")
    return()
  endfunction()