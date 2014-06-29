#replaces all occurrences of pattern with replace in str and returns str
function(string_replace str pattern replace)
  string(REPLACE "${pattern}" "${replace}" res "${str}")
  return_ref(res)
endfunction()