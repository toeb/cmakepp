
  function(template_eval template)
    template_generate("${template}")
    ans(template_code)
    eval("${template_code}")
    return_ans()
  endfunction()
