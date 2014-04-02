# assigns the result return by a functi on to the specified variable
# must be immediately called after funct ion call
# if no argument is passed current __ans will be cleared (this should be called at beginning of ffunc)
# the name ans stems from calculators ans and signifies the last answer
function(ans result)
  set(${result} "${__ans}" PARENT_SCOPE)
endfunction()