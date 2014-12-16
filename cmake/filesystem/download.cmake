## download(url [target] [--progress])
## downloads the specified url to specified target path
## if target path is an existing directory the files original filename is kept
## else target is treated as a file path and download stores the file there
## if --progress is specified then the download progress is shown
## returns the path of the successfully downloaded file or null
function(download url)
  set(args ${ARGN})

  list_extract_flag(args --progress)
  ans(show_progress)
  if(show_progress)
    set(show_progress SHOW_PROGRESS)
  else()
    set(show_progress)
  endif()

  path("${args}")
  ans(target_path)


  path_component("${url}" --file-name-ext)
  ans(filename)

  if(IS_DIRECTORY "${target_path}")
    set(target_path "${target_path}/${filename}")    
  endif()


  file(DOWNLOAD "${url}" "${target_path}" STATUS status ${show_progress})

  list_extract(status code message)
  if(NOT "${code}" STREQUAL 0)    
    return()
  endif()

  return_ref(filename)
endfunction()