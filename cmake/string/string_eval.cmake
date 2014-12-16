## evaluates the string <str> in the current scope
## this is done by macro variable expansion
## evaluates both ${} and @@ style variables
macro(string_eval str)
  set_ans("${str}")
endmacro()