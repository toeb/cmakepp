## (<string...>) -> <void>
## 
## writes the specified string(s) to the templates output
## fails if not called inside a template
##
function(template_write)
  template_guard()
  ans(ref)
  ref_append_string("${ARGN}")
  return()
endfunction()
 