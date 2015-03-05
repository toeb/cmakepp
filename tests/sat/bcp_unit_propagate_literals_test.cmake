function(test)
  function(test_bcp cnf assignments)
    cnf("${cnf}")
    ans(f)
    map_tryget(${f} clause_literal_map)
    ans(clause_literal_map)
    assign(ai = "f.atom_index_map.${atom}")
    data("${assignments}")
    ans(assignments)

    atom_to_literal_assignments(${f} ${assignments})
    ans(assignments)
    map_keys(${assignments} )
    ans(literals)

   # print_vars(literals assignments)

    timer_start(bcp_timer)
    bcp("${f}" "${clause_literal_map}" "${assignments}" ${literals})
    ans(res)
    timer_print_elapsed(bcp_timer)

    if("${res}" MATCHES "(unsatisfied)|(conflict)")
      return(${res})
    endif()
    literal_to_atom_assignments(${f} ${assignments})
    ans(res)
    return_ref(res)
  endfunction()

  define_test_function(test_uut test_bcp cnf atoms )


  test_uut("{a:'false'}" "!a" "{}")
  test_uut("conflict" "a;!a" "{}")
  test_uut("{c:'true', b:'true', a:'false'}" "!a|!b;b|!c" "{c:'true'}")
  test_uut("{a:'true',b:'false'}" "a;!b" "{}")
  test_uut("{a:'true'}" "a" "{}")
  test_uut("{a:'true',b:'true'}" "a;b" "{}")
  #test_uut("conflict" "a;!a;b" "a" true)
  #test_uut("{a:'true',b:'false'}" "a;!b" "a" true)
endfunction()




