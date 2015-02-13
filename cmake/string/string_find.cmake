
  function(string_find str substr)
    set(args ${ARGN})
    list_extract_labelled_keyvalue(args --reverse REVERSE)
    ans(reverse)
    string(FIND "${str}" "${substr}" idx ${reverse})
    return_ref(idx)
  endfunction()