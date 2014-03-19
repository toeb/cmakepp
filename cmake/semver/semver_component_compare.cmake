
 function(semver_component_compare result left right)
 # message("comapring '${left}' to '${right}'")
    string_isempty(left_empty "${left}")
    string_isempty(right_empty "${right}")

    # filled has precedence before nonempty
    if(left_empty AND right_empty)
      return_value(0)
    elseif(left_empty AND NOT right_empty)
      return_value(1)
    elseif(right_empty AND NOT left_empty)
      return_value(-1)
    endif() 


    string_isnumeric(left_numeric "${left}")
    string_isnumeric(right_numeric "${right}")

    # if numeric has precedence before alphanumeric
    if(right_numeric AND NOT left_numeric)
      return_value(-1)
    elseif(left_numeric AND NOT right_numeric)
      return_value(1)
    endif()


   
    if(left_numeric AND right_numeric)
      if(${left} LESS ${right})
        return_value(1)
      elseif(${left} GREATER ${right})
        return_value(-1)
      endif()
      return_value(0)
    endif()

    if("${left}" STRLESS "${right}")
      return_value(1)
    elseif("${left}" STRGREATER "${right}")
      return_value(-1)
    endif()

    return_value(0)
 endfunction()