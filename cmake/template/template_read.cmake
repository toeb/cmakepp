## template_read()->
##
function(template_read path)
  fread("${path}")
  ans(content)
  template_generate("${content}")
  return_ans()
endfunction()