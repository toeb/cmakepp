

  function(qm2_serialize)
      function(qm2_ref_format)
        set(prop)
        if(ARGN)
          set(prop ".${ARGN}")
        endif()
        set(__ans ":\${ref}${prop}" PARENT_SCOPE)
      endfunction()

     # define callbacks for building result
    function(qm2_obj_begin)
      map_tryget(${context} ${node})
      ans(ref)
      map_push_back(${context} refstack ${ref})
      map_append_string(${context} qm 
"math(EXPR ref \"\${base} + ${ref}\")
")
    endfunction()

    function(qm2_obj_end)
      map_pop_back(${context} refstack)
      map_peek_back(${context} refstack)
      ans(ref)

      map_append_string(${context} qm 
"math(EXPR ref \"\${base} + ${ref}\")
")
    endfunction()
    
    function(qm2_obj_keyvalue_begin)
      qm2_ref_format()
      ans(keystring)
      qm2_ref_format(${map_element_key})
      ans(refstring)
      
      map_append_string(${context} qm 
"set_property(GLOBAL APPEND PROPERTY \"${keystring}\" \"${map_element_key}\")
set_property(GLOBAL PROPERTY \"${refstring}\")
")
    endfunction()

    function(qm2_literal)
      qm2_ref_format(${map_element_key})
      ans(refstring)
      cmake_string_escape("${node}")
      ans(node)
      map_append_string(${context} qm 
"set_property(GLOBAL APPEND PROPERTY \"${refstring}\" \"${node}\")
")
      return()
    endfunction()

    function(qm2_unvisited_reference)
      map_tryget(${context} ref_count)
      ans(ref_count)
      math(EXPR ref "${ref_count} + 1")
      map_set_hidden(${context} ref_count ${ref})
      map_set_hidden(${context} ${node} ${ref})

      qm2_ref_format(${map_element_key})
      ans(refstring)

      map_append_string(${context} qm
"math(EXPR value \"\${base} + ${ref}\")
set_property(GLOBAL PROPERTY \":\${value}.__type__\" \"map\")
set_property(GLOBAL APPEND PROPERTY \"${refstring}\" \":\${value}\")
")
    endfunction()
    function(qm2_visited_reference)
map_tryget(${context} "${node}")
ans(ref)

  qm2_ref_format(${map_element_key})
  ans(refstring)
map_append_string(${context} qm
"#revisited node
math(EXPR value \"\${base} + ${ref}\")
set_property(GLOBAL APPEND PROPERTY \"${refstring}\" \":\${value}\")
# end of revisited node
")


    endfunction()
     map()
      kv(value              qm2_literal)
      kv(map_begin          qm2_obj_begin)
      kv(map_end            qm2_obj_end)
      kv(map_element_begin  qm2_obj_keyvalue_begin)
      kv(visited_reference  qm2_visited_reference)
      kv(unvisited_reference  qm2_unvisited_reference)
    end()
    ans(qm2_cbs)
    function_import_table(${qm2_cbs} qm2_callback)

    # function definition
    function(qm2_serialize)        
      map_new()
      ans(context)
      map_set(${context} refstack 0)
      map_set(${context} ref_count 0)
  
      dfs_callback(qm2_callback ${ARGN})
      map_tryget(${context} qm)
      ans(res)
      map_tryget(${context} ref_count)
      ans(ref_count)

      set(res "#qm/2.0
set(base \${ref_count})
set(ref \${base})
${res}set(ref_count ${ref_count})
")

      return_ref(res)  
    endfunction()
    #delegate
    qm2_serialize(${ARGN})
    return_ans()
  endfunction()
