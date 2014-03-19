 function(semver_format version)
     map_isvalid(${version} ismap)
     if(NOT ismap)
      semver_parse(${version} RESULT version)
     endif()

   endfunction()