
  ## 
  ## opens the specified template and runs it in its directory
  ## * returns 
  ##    * the output of the template
  ## * scope
  ##    * `pwd()` is set to the templates path
  ##    * `${template_path}` is set to the path of the current template
  ##    * `${template_dir}` is set to the directory of the current template
  function(template_run template_path)
    template_read("${template_path}")
    ans(template)

    get_filename_component(template_dir "${template_path}" PATH)
    pushd("${template_dir}")
    eval("${template}")
    ans(result)
    popd()
    return_ref(result)
  endfunction()