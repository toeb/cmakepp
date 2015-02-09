function(test)



function(cmakepp_compile_docs)
  oocmake_config(base_dir)
  ans(base_dir)
  file(GLOB_RECURSE template_paths "${base_dir}/**README.md.in")
  
  foreach(template_path ${template_paths})
      get_filename_component(template_dir "${template_path}" PATH)
      set(output_file "${template_dir}/README.md")
      template_run("${template_path}")
      ans(generated_content)
      fwrite("${output_file}" "${generated_content}")
  endforeach()

endfunction()

cmakepp_compile_docs()
endfunction()