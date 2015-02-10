## (<file path>)-> <cmake code>
## 
## reads the contents of the specified path and generates a template from it
## * return
##   * the generated template code
##
function(template_read path)
  fread("${path}")
  ans(content)
  template_generate("${content}")
  return_ans()
endfunction()