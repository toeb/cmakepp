# creates random none existing file using a pattern
# the first file which does not exist is returned
function(file_random  in_pattern)
  while(true)
    make_guid()
    ans(id)
	  string(REPLACE "{{id}}" ${id} in_pattern ${in_pattern})
    set(current_name "${in_pattern}")
    if(NOT EXISTS ${current_name})
      return_ref(current_name)
    endif()
  endwhile()
endfunction()