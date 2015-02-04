## --json only returns the content or nothing
function(http_get url content)
  set(args ${ARGN})
  list_extract_flag(args --json)
  ans(json_content)
  list_extract_flag(args --progress)
  ans(show_progress)
  if(show_progress)
    set(show_progress SHOW_PROGRESS)
  else()
    set(show_progress)
  endif()

  file_make_temporary(nothing)
  ans(target_path)

  obj("${content}")
  ans(content)

  uri_format("${url}" "${content}")
  ans(url)

  file(DOWNLOAD 
    "${url}" "${target_path}" 
    STATUS status 
    LOG http_log
    ${show_progress}
    TLS_VERIFY OFF 
    ${args}
  )

  http_last_response_parse("${http_log}")
  ans(result)

  list_extract(status client_status client_message)

  map_set(${result} client_status "${client_status}")
  map_set(${result} client_message "${client_message}")
  map_set(${result} request_url "${url}")

  fread("${target_path}")
  ans(content)
  map_set(${result} content "${content}")

  string(LENGTH "${content}" strlen)
  map_set(${result} content_length "${strlen}")
  map_set(${result} http_log "${http_log}")


  if(json_content)
    if(client_status)
      set(content)
    endif()
    json_deserialize("${content}")
    return_ans()
  endif()

  # 
  return_ref(result)
endfunction()