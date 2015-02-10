## (<structured data...>) -> <void>
## 
## writes the serialized data to the templates output
## fails if not called inside a template
##
function(template_write_data)
  json_indented(${ARGN})
  ans(res)
  template_write("${res}")
  return()
endfunction()
