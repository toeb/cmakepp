function(expr_compile_function) # context, ast
 # message("expr_compile_function")

  map_tryget(${ast} children)
  ans(children)

  #message("children ${children}")

  list_extract(children signature_ast body_ast)

  map_tryget(${signature_ast} children)
  ans(signature_identifiers)
  set(signature_vars)
  set(identifiers)
  foreach(identifier ${signature_identifiers})
    map_tryget(${identifier} data)
    ans(identifier)
    list(APPEND identifiers "${identifier}")
    set(signature_vars "${signature_vars} ${identifier}")
  endforeach()  
  #message("signature_identifiers ${identifiers}")

  map_tryget(${body_ast} types)
  ans(body_types)

  list_contains(body_types closure)
  ans(is_closure)
  #list_contains(body_types expression)
  #ans(is_expression)
  if(is_closure)
   # message("is_closure")
    map_tryget(${body_ast} children)
    ans(body_ast)
#  elseif(is_expression)
   # message("is_expression")
  endif()

 # message("body_types ${body_types}")

  ast_eval(${body_ast} ${context})
  ans(body)

set(res "
#expr_compile_function
function_new()
ans(left)
function(\"\${left}\"${signature_vars})
  map_new()
  ans(local)  
  map_capture(\"\${local}\" this global${signature_vars})
  ${body}
  return_ans()
endfunction()
#end of expr_compile_function")
  
  return_ref(res)  
endfunction()