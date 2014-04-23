function(list_length __list_count_lst)
    list(LENGTH "${__list_count_lst}" len)
    return("${len}")
endfunction()
