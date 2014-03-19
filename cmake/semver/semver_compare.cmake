function(semver_compare result left right)

# message("comapring ${left} to ${right}")
 semver_parse(${left} MAJOR left_maj MINOR left_min PATCH left_patch PRERELEASE left_pre)
 semver_parse(${right} MAJOR right_maj MINOR right_min PATCH right_patch PRERELEASE right_pre)

 semver_component_compare(cmp ${left_maj} ${right_maj})
 if(NOT ${cmp} STREQUAL 0)
  return_value(${cmp})
endif()
 semver_component_compare(cmp ${left_min} ${right_min})
 if(NOT ${cmp} STREQUAL 0)
  return_value(${cmp})
endif()
 
 semver_component_compare(cmp ${left_patch} ${right_patch})
 if(NOT ${cmp} STREQUAL 0)
  return_value(${cmp})
endif()


 if(right_pre AND NOT left_pre)
  return_value(true)
 endif()

 if(left_pre AND NOT right_pre)
  return(false)
 endif()

 # iterate through all identifiers of prerelease
 while(true)
    list_first(left_current ${left_pre})
    list_rest(left_pre ${left_pre})

    list_first(right_current ${right_pre})
    list_rest(right_pre ${right_pre})

    # check for larger set
    if(right_current AND NOT left_current)
      return_value(1)
    elseif(left_current AND NOT right_current)
      return_value(-1)
    elseif(NOT left_current AND NOT right_current)
      # equal
      return_value(0)
    endif()

      # compare component
   semver_component_compare(cmp ${left_current} ${right_current})
   if(NOT ${cmp} STREQUAL 0)
    return_value(${cmp})
   endif()



    
 endwhile()
 
 return_value(0)

endfunction()