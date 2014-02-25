function(test)
call_function("function(fu arg1 arg2)\n set(result \"asd \${arg1} \${arg1} \${arg2} \${arg2}\" PARENT_SCOPE) \n endfunction()" a b)
assert("${result}" STREQUAL "asd a a b b")

endfunction()