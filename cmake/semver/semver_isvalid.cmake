#returns the version object iff the version  is valid
# else returns false
# validity:
# it has a major, minor and patch version field with valid numeric values [0-9]+
# accepts both a version string or a object
# 
function(semver_isvalid version)
  # get version object
  semver("${version}")
  ans(version)

  nav(version.major)
  ans(current)
  string_isnumeric( "${current}")
  ans(numeric)
  #message("curent ${current} : numeric ${numeric}")
  if(NOT numeric)
    return(false)
  endif()

  nav(version.minor)
  ans(current)
  string_isnumeric( "${current}")
  ans(numeric)
 # message("curent ${current} : numeric ${numeric}")
  if(NOT numeric)
    return(false)
  endif()

  nav(version.patch)
  ans(current)
  string_isnumeric( "${current}")
  ans(numeric)
#  message("curent ${current} : numeric ${numeric}")
  if(NOT numeric)
    return(false)
  endif()

  return(true)
endfunction()