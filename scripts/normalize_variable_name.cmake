
# removes all characters not allowed in variable names and replaces them with and underscore
function(normalize_variable_name result_var input)
  set(input ${input})
  string(REPLACE "+" "_" input ${input})
  string(REPLACE ":" "_" input ${input})
  string(REPLACE "/" "_" input ${input})
  string(REPLACE "\\" "_" input ${input})
  string(REPLACE "." "_" input ${input})
  set(${result_var} ${input} PARENT_SCOPE)
endfunction()