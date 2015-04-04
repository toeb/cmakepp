## `(<dependency constraint> <reason:<string>> <<literal>|<negated literal>>...)-><dependency constraint clause>`
##
## ```
## <package dependency constraint clause> ::= {
##   reason: <string>
##   literals: <["!"] <package uri>>...
## } 
## ```
##
## creates the specified clause and returns it. expects literals to be package handles
## adds the clause to the constraints clauses property. A good reason helps the user
## debug the dependency problem should an error occur. The reason is formatted ie strings may contain `{<navigation expressions>}`
function(package_dependency_constraint_clause_new constraint reason)
  ## format reason
  format("${reason}")
  ans(reason)


  map_new()
  ans(clause)
  map_set(${clause} reason "${reason}")
  ## loop through all literals and add them to the clause object
  set(literals ${ARGN})
  foreach(literal ${literals})
    if("${literal}" MATCHES "^!(.+)")
      map_tryget(${CMAKE_MATCH_1} uri)
      ans(uri)
      map_append(${clause} literals "!${uri}")
    else()
      map_tryget(${literal} uri)
      ans(uri)
      map_append(${clause} literals "${uri}")
    endif()
  endforeach()

  ## add clause to constraint's claues property and set 
  ## the clause's constraint property
  map_set(${clause} constraint ${constraint})
  map_append(${constraint} clauses ${clause})

  return(${clause})
endfunction()