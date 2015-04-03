## `()->` 
## 
## rethrows if the last return value was an exception
## else changes nothing
macro(rethrow)
  set(___ans "${__ans}")
  is_exception("${__ans}")
  if(__ans)
    throw("${___ans}")
  endif()
  set(__ans "${___ans}")
endmacro()