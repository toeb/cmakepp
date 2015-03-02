
  function(print_cnf f)
    scope_import_map(${f})
    print_multi(${c_last} clauses clause_literals clause_atoms)
    print_multi(${a_last} atoms atom_literals atom_clauses)
    print_multi(${l_last} literals literal_inverse literal_negated literal_clauses literal_atom)

  endfunction()
