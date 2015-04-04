## `(<dependency changeset>|<change ...>)-><dependency changeset>`
##
## returns a `<dependency changeset>`
## ```
## <dependency changeset>::={
##  <<admissable uri>:<dependency constraint>>... 
## }
## <change> ::= <admissable uri> [" " <dependency constraint> | "remove"  ] 
## ``` 
##
function(package_dependency_changeset)
  is_address("${ARGN}")
  ans(isref)
  if(isref)
    return(${ARGN})
  endif()
  package_dependency_changeset_parse(${ARGN})
  return_ans()
endfunction()
