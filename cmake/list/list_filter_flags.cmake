# returns only those flags which are contained in list and in the varargs
# ie list = [--a --b --c --d]
# list_filter_flags(list --c --d --e) ->  [--c --d]
function(list_filter_flags __list_filter_flags_lst)
  set(__list_filter_flags_flags ${ARGN})
  list_intersect(${__list_filter_flags_lst} __list_filter_flags_flags)
  return_ans()
endfunction()