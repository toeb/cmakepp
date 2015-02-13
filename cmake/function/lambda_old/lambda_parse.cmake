
# creates a function from the lambda expressio in code.
# syntax for lambdas: (arg1 arg2 ... argn)->COMMAND;COMMAND;...
# if no return() is called lambda will return_ans() at the end 
# which returns whatever was returned last
# instead of ${var} syntax use $var for variables
# use {expr} for evaluating expressions
function(lambda_parse code)
  message(WARNING "old lambda is deprecated ")
  string(REPLACE "'" "\"" code "${code}")
  string(REPLACE ");" ")\n" code "${code}")

  string_replace_first("(" "function(lambda_func "  "${code}")
  ans(code)
  string_replace_first(")->" ")\nset(__ans)\n" "${code}")
  ans(code)
  string(REGEX MATCHALL "{[^}]*}" expressions "${code}")

  if(expressions)
    foreach(expression ${expressions})
      string(RANDOM  tmp_var_name)
      set(tmp_var_name "__tmp_var_${tmp_var_name}")
      
      string_slice("${expression}" 1 -2)
      ans(eval_this)
      set(eval_string "expr(\"${eval_this}\")\nans(${tmp_var_name})\n")
      string_regex_escape("${expression}")
      ans(expression)
      string_regex_escape("${eval_string}")
      ans(eval_string)
      string(REPLACE "\\" "\\\\" eval_string "${eval_string}")
      set(repl "\\1\n${eval_string}\\2\\\\\$${tmp_var_name}")
    #  message("replace ${repl}")
    #  message("expression '${expression}'")
      set(regex "(\n)([^\n]*)(${expression})")
      string(REGEX MATCH "${regex}" match "${code}")
     # message("match ${match}\n")
      string(REGEX REPLACE "${regex}" "${repl}" code "${code}")
    endforeach()
    string(REPLACE "\\." "." code "${code}")
    string(REPLACE "\\$" "$" code "${code}")
  endif()

    string(REGEX MATCHALL "(\\$[a-zA-Z0-9-_\\.]+)" matches "${code}")
    list(REMOVE_DUPLICATES matches)
    foreach(match ${matches})
      string(REPLACE "$" "\${" repl "${match}")
      set(repl "${repl}}")
      string(REPLACE "${match}" "${repl}" code "${code}")
    endforeach()
    set(code "${code}\nreturn_ans()\nendfunction()")
    return_ref(code)
  endfunction()