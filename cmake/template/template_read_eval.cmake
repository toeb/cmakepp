
  function(template_read_eval path)
    template_read("${path}")
    ans(template)
    eval("${template_code}")
    return_ans()
  endfunction()