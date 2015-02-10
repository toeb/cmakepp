## `(<file path>)-><file path>`
##
## compiles the specified file (which is expected to end with `.in`) to the same path without the `.in`
## Uses `template_run` internally.
## returns the path to which it was compiled
##
function(template_compile_to template_path)
  if(NOT "${template_path}" MATCHES "\\.in$")
    message(FATAL_ERROR "expected a '.in' file")
  endif()

  string(REGEX REPLACE "(.+)\\.in" "\\1" output_file "${template_path}" )

  get_filename_component(template_dir "${template_path}" PATH)

  template_run("${template_path}")
  ans(generated_content)
  fwrite("${output_file}" "${generated_content}")

  return("${output_file}")
endfunction()
