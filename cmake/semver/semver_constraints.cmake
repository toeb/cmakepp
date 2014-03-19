
function(semver_constraints result constraint_text version)
  string_split(constraints "${constraint_text}" ",")
  foreach(constraint ${constraints})
    semver_constraint(constraint_ok "${constraint}" "${version}")
    if(NOT constraint_ok)
      return_value(false)
    endif()
  endforeach()
  return_value(true)

endfunction()