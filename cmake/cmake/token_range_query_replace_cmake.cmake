
  function(token_range_query_replace_cmake start end code)
    assign(start_token = "${start}")
    set(end_token)
    if(end)
      assign(end_token = "${end}")
    endif()
    token_range_replace_cmake("${start_token}" "${end_token}" "${code}")
  endfunction()