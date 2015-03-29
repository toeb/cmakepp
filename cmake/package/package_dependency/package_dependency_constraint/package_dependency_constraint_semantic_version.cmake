## `()->`
## 
## constrains the semantic version of a dependency
function(package_dependency_constraint_semantic_version
  dependency_problem 
  dependee
  admissable_uri 
  dependency_constraint
  possible_dependencies)

  ## if dependency constraint does not have a version property then ignore
  map_has(${dependency_constraint} version)
  ans(has_version_constraint)
  if(NOT has_version_constraint)
    return()
  endif()

  ## get version constraint and compile it
  map_tryget(${dependency_constraint} version)
  ans(version_constraint)

  semver_constraint_compile("${version_constraint}")
  ans(compiled_version_constraint)


  ## create the package constraint to return 
  package_dependency_constraint_new("semantic_version" "${dependee}")
  ans(constraint)


  ## loop through all possible dependencies and if the version constraint does not hold 
  ## add a incompatibility clause to the cosntraint
  map_values(${possible_dependencies})  
  ans(dependencies)
  foreach(dependency ${dependencies})

    ## check version agains the version constraint
    map_tryget(${dependency} package_descriptor)
    ans(package_descriptor)
    map_tryget(${package_descriptor} version)
    ans(version)
    semver_constraint_compiled_evaluate("${compiled_version_constraint}" "${version}")
    ans(holds)

    ## if incompatible add incompatibility
    if(NOT holds)
      package_dependency_constraint_clause_new(
        ${constraint}
        "{dependee.uri} => {admissable_uri}: is incompatible with {dependency.uri} because version constraint '${version_constraint}' does not hold for '${version}'"
        "!${dependee}"
        "!${dependency}"
        )
    endif()

  endforeach()

  ## success returns a valid package_dependency_constraint
  return(${constraint})

endfunction()