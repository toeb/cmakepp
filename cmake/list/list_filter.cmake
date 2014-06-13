
 # filters all elements of list by applying a predicate
# and returning those items for which predicate(item) == true
function(list_filter __list_filter_lst predicate)
  curry("${predicate}"(/1) as __predicate)
  set(__list_filter_items)
  foreach(item ${${__list_filter_lst}})
    __predicate("${item}")
    ans(predicate_matches)
    if(predicate_matches)
      list(APPEND __list_filter_items "${item}")
    endif() 
  endforeach()
  return_ref(__list_filter_items)
endfunction()