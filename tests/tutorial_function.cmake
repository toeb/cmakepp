function(tutorial)


## creating functions

## the plain cmake function (with input and output vars)
## =====================================================
# defining a function:
function(my_function arg)
	set(out_value "${arg}" PARENT_SCOPE)
endfunction()
# calling the function:
my_function("sample1")
assert(out_value)
assert(${out_value} STREQUAL "sample1")


# -> things to note about plain cmake functions:  
# -> cmake only has one global namespace for functions (no scoping like with variables)
# -> functions can be overwritten (even functions defined by cmake)
# -> functions cannot be called dynamically (ala '${dynamic_name}(args)')
# -> functions can be defined dynamically ( function(${dynamic_name} arg1 arg2) .... endfunction())

## dynamically calling a function  'function_call'
## ===============================================
function(my_function arg)
  return("${arg}")
endfunction()
set(function_name my_function)
function_call(${function_name} (sample2))
ans(result)
assert("${result}" STREQUAL "sample2")

# -> things to not about dynamic function calls:
# -> no out parameters, only return values


## declaring, defining and calling a unique dynamic function
## =========================================================
new_function(my_unique_function)
assert(COMMAND ${my_unique_function})
# my_unique_function now contains a unique string e.g. func_nTGSmkIGHL
# it is only declared. uncommenting the following line results in a FATAL_ERROR
# call_function(${my_unique_function})
#the function still has to be defined: 
function(${my_unique_function} arg1 arg2)
	return("${arg2} ${arg1}" )
endfunction()
# call function
function_call(${my_unique_function} (world hello))
ans(res)
assert(${res} STREQUAL "hello world")


## calling a function string
## =========================
# you can call any string that is a cmake function
# it does not matter what name the function has
# be sure to escape the string correctly
# WARNING using ; and ${ARGN} or carriage returns may lead to unexpected results 
# incorrectly escaping variables will be cause of many a bug
function_call("function(fu arg1 arg2)\n return(\"\${arg1} \${arg1} \${arg2} \${arg2}\") \n endfunction()" (a b))
ans(res)
assert("${res}" STREQUAL "a a b b")

return()
# changes reflect up to here

## importing a function
## ====================
#any kind of function can be imported 
# the REDEFINE flag allows a function to be overwritten (not setting it would cause an error if a function fuu already exists (2. and 3. call))
# a usefull application iterating a list of files containing unit test functions and calling each with the same name
# also when working with packages this allows functions to be defined in a specified namespace
import_function(my_function as fuu REDEFINE)
fuu(sample4)
assert(${result} STREQUAL "sample4")
import_function(${file_name} as fuu REDEFINE)
fuu(a b) 
assert(${result} STREQUAL "a b")
import_function("function(fu arg1 arg2) \n set(result \"\${arg1} \${arg1} \${arg2} \${arg2}\" PARENT_SCOPE) \n endfunction()" as fuu REDEFINE)
fuu(a b)
assert(${result} STREQUAL "a a b b")
return()



endfunction()