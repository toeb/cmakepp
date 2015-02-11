## `()-><void>`
## begins a new template after calling this inner template functions start
## to work (like template_out())
##
function(template_begin)
  ref_new()
  ans(ref)
  set(__template_output_stream ${ref} PARENT_SCOPE)
endfunction()
