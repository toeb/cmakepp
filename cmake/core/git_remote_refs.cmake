# returns a list of ref maps containing the fields 
# name type and revision
function(git_remote_refs result uri)
set(success)
    git(ls-remote "${uri}" RESULT success STDOUT res)
 #   messagE("${success}")
    if(NOT success)
      return_value()
    endif()

    string_split(lines "${res}" "\n")
    set(res)
    foreach(line ${lines})
      string(STRIP "${line}" line)

      # match
      if("${line}" MATCHES "^([0-9a-fA-F]*)\t(.*)$")
        string(REGEX REPLACE "^([0-9a-fA-F]*)\t(.*)$" "\\1;\\2" parts "${line}")
        list_extract(parts revision ref)
        git_ref_parse(ref_map "${ref}")
        if(ref_map)
          map_set(${ref_map} revision ${revision})
          set(res ${res} ${ref_map})
          #ref_print(${ref_map})
        endif()
      endif()
    endforeach()   
    set(${result} ${res} PARENT_SCOPE)
endfunction()