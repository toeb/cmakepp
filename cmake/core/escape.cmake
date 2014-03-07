
# escapes input sets output
function(escape output input)
#"()#$^
 string(REPLACE "\\" "\\\\" input ${input})
 string(REPLACE "$" "\\$" input ${input})
 #string(REPLACE "^" "\\^" input ${input})
 #string(REPLACE "^" "\\^" input ${input})
 set(${output} ${input} PARENT_SCOPE)
endfunction()