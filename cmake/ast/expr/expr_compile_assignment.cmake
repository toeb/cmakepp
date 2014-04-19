function(expr_compile_assignment) # scope, ast

  #message("compiling assignment")
  map_tryget(${ast} children children)
  list_extract(children lvalue_ast rvalue_ast)

  map_tryget(${lvalue_ast} types types)
  list_extract(types lvalue_type) 
  set(res)

  if("${lvalue_type}" STREQUAL "cmake_identifier" )
    #message("assigning cmake identifier")
    map_tryget(${lvalue_ast} children children)
    list_extract(children identifier_ast)
    map_tryget(${identifier_ast} identifier data)
    set(res "  set(assignment_scope \"\${global}\")")
  elseif("${lvalue_type}" STREQUAL "identifier")
   # message("assigning identifier")
    map_tryget(${lvalue_ast} identifier data)
    set(res "  set(assignment_scope \"\${this}\")")
  endif()

  ast_eval(${rvalue_ast} ${context})
  ans(rvalue)
  set(res "
  # expr_compile_assignment
  ${rvalue}
  ans(rvalue)
  ${res}
  map_set(\"\${assignment_scope}\" \"${identifier}\" \"\${rvalue}\" )
  set_ans_ref(rvalue)
  # end of expr_compile_assignment")

  return_ref(res)  
endfunction()