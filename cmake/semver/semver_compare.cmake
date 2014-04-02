function(semver_compare result left right)
 semver_parse(${left} )
 ans(left)
 semver_parse(${right})
 ans(right)

map_import(${left} left)
map_import(${right} right)

 semver_component_compare(cmp ${left_major} ${right_major})
 if(NOT ${cmp} STREQUAL 0)
  return_value(${cmp})
endif()
 semver_component_compare(cmp ${left_minor} ${right_minor})
 if(NOT ${cmp} STREQUAL 0)
  return_value(${cmp})
endif()
 
 semver_component_compare(cmp ${left_patch} ${right_patch})
 if(NOT ${cmp} STREQUAL 0)
  return_value(${cmp})
endif()


 if(right_prerelease AND NOT left_prerelease)
  return_value(-1)
 endif()

 if(left_prerelease AND NOT right_prerelease)
  return(1)
 endif()
 # iterate through all identifiers of prerelease
 while(true)
    list_first(left_current ${left_tags})
    list_rest(left_tags ${left_tags})

    list_first(right_current ${right_tags})
    list_rest(right_tags ${right_tags})

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

   #   message("asd '${left_current}'  '${right_current}' -> ${cmp}")
   if(NOT ${cmp} STREQUAL 0)
    return_value(${cmp})
   endif()



    
 endwhile()
 
 return_value(0)

endfunction()