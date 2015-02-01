
function(mime_type_from_filename file)
  get_filename_component(extension "${file}" EXT)
  mime_type_from_extension("${extension}")
  return_ans()
endfunction()