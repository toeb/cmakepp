## `()->`
##
##  
## 
## creates a conjunctive normal form from the specified input
## {
##   clauses: clause-0 ... clause-n
##   c_n: number of clauses (n+1)
##   c_last: index of last clause (n)
##   clause_atoms: map contains a list of indices of all atoms contained in clause i
##   clause_literals: map contains a list of indices of all literals contained in clause i 
##   atoms: atom-0 ... atom-n 
##   a_n: number of atoms (n+1)
##   a_last: last index of atoms (n)
##   atom_literals: a map contains the indices of all literals for atom i 
##   atom_clauses:  map contains the clauses which reference atom i
##   literals: literal-0 ... literal-n
##   l_n:  number of literals 
##   l_last: index of last literal 
##   literal_atom:  literal_atom[i] = atom for literal i
##   literal_negated: bool[i]
##   literal_inverse: literal[i]-> index
##   literal_clauses: map[i]->list of indices 
## }
## 
function(cnf)
  set(ci 0)
  set(ai 0)
  set(li 0)
  map_new()
  ans(literal_index_map)
  map_new()
  ans(atom_index_map)

  set(clauses)
  map_new()
  ans(clause_atoms)
  map_new()
  ans(clause_literals)

  set(literals)
  set(literal_atom)
  set(literal_negated)
  set(literal_inverse)
  map_new()
  ans(literal_clauses)

  set(atoms)
  map_new()
  ans(atom_literals)
  map_new()
  ans(atom_clauses)


  macro(cnf_parse_literal)
    set(atom ${literal})
    set(negated false)
    if("${atom}" MATCHES "!(.+)")
      set(atom "${CMAKE_MATCH_1}")
      set(negated true)
    endif()           
  endmacro()

  set(input ${ARGN})

  string(REPLACE "-" "!" input "${input}")
  string(REPLACE " " "|" input "${input}" )
  string(REPLACE "\n" ";" input "${input}")
  string(REPLACE "&" ";" input "${input}")


  foreach(clause ${input})
    list(LENGTH clauses ci)
    list(APPEND clauses "${clause}")
    string(REPLACE "|" ";" clause "${clause}")

    foreach(literal ${clause})    
      cnf_parse_literal()
      ## atom, negated, literal
      list(FIND atoms "${atom}" ai)
      if(ai LESS 0)
        list(LENGTH atoms ai)
        list(APPEND atoms "${atom}")
        map_set(${atom_index_map} "${atom}" ${ai})


        list(LENGTH literals li)

        math(EXPR li "${li} + 1")
        list(APPEND literals "${atom}")
        list(APPEND literal_negated false)
        list(APPEND literal_atom "${ai}")
        list(APPEND literal_inverse "${li}")
        map_set(${literal_index_map} "${atom}" "${li}")

        math(EXPR li "${li} - 1")          
        list(APPEND literals "!${atom}")
        list(APPEND literal_negated true)
        list(APPEND literal_atom "${ai}")
        list(APPEND literal_inverse "${li}")
        map_set(${literal_index_map} "!${atom}" "${li}")
      endif()

      list(FIND literals "${literal}" li)
      # if(li LESS 0)
        
      #   list(LENGTH literals li)
      #   list(APPEND literals "${literal}")
      #   list(APPEND literal_negated "${negated}")
      #   list(APPEND literal_atom "${ai}")

      # endif()

      map_append_unique("${literal_clauses}" ${li} ${ci})
      map_append_unique("${atom_clauses}" ${ai} ${ci})
      map_append_unique("${atom_literals}" ${ai} ${li})

      map_append_unique("${clause_literals}" ${ci} ${li}) 
      map_append_unique("${clause_atoms}" ${ci} ${ai}) 
    endforeach() #literal   

  endforeach() #clause 

  list(LENGTH literals l_n)

  math(EXPR l_last "${l_n} - 1")


  list(LENGTH atoms a_n)
  math(EXPR ai "${a_n} - 1")

  set(a_last ${ai})
  set(c_last ${ci})


  math(EXPR c_n "${c_last} + 1")


  foreach(i RANGE 0 ${c_last})

  endforeach()
  foreach(i RANGE 0 ${a_last})

  endforeach()
  map_new()
  ans(literal_map)
  map_new()
  ans(literal_negated_map)
  map_new()
  ans(literal_inverse_map)
  map_new()
  ans(literal_atom_map)
  foreach(i RANGE 0 ${l_last})
    list(GET literals ${i} val)
    map_set(${literal_map} ${i} ${val})
    list(GET literal_negated ${i} val)
    map_set(${literal_negated_map} ${i} ${val})
    list(GET literal_inverse ${i} val)
    map_set(${literal_inverse_map} ${i} ${val})
    list(GET literal_atom ${i} val)
    map_set(${literal_atom_map} ${i} ${val})
  endforeach()

  map_new()
  ans(clause_map)
  set(clause_atom_map ${clause_atoms})
  set(clause_literal_map ${clause_literals})

  foreach(i RANGE 0 ${c_last})
    list(GET clauses ${i} val)
    map_set(${clause_map} ${i} ${val})
  endforeach()


  map_new()
  ans(atom_map)
  map_new()
  ans(atom_literal_negated_map)
  map_new()
  ans(atom_literal_identity_map)
  foreach(i RANGE 0 ${a_last})
    list(GET atoms ${i} val)
    map_set(${atom_map} ${i} ${val})
    math(EXPR literal_id_i "${i} * 2")
    math(EXPR literal_neg_i "${i} * 2 + 1")
    map_set(${atom_literal_identity_map} ${i} ${literal_id_i} )
    map_set(${atom_literal_negated_map} ${i} ${literal_neg_i})
  endforeach()  




  set(atom_literal_map ${atom_literals})
  set(atom_clause_map ${atom_clauses})

  map_capture_new(
    clauses 
    c_n 
    c_last 
    clause_atoms
    clause_literals
    
    clause_map
    clause_atom_map
    clause_literal_map

    atoms 
    a_n 
    a_last 
    atom_clauses
    atom_literals

    atom_map
    atom_clause_map
    atom_literal_map
    atom_literal_negated_map
    atom_literal_identity_map
    atom_index_map

    literals 
    l_n 
    l_last 
    literal_clauses
    literal_atom
    literal_inverse
    literal_negated
    
    literal_map
    literal_atom_map
    literal_inverse_map
    literal_negated_map
    literal_index_map
  )
  return_ans()
endfunction()



  function(cnf clause_map)

    map_keys("${clause_map}")
    ans(clause_indices)

    sequence_new()
    ans(literal_map)
    sequence_new()
    ans(atom_map)
    sequence_new()
    ans(atom_literal_map)
    sequence_new()
    ans(literal_atom_map)
    map_new()
    ans(literal_index_map)
    map_new()
    ans(atom_index_map)
    sequence_new()
    ans(literal_negated_map)
    sequence_new()
    ans(literal_inverse_map)
    sequence_new()
    ans(atom_literal_negated_map)
    sequence_new()
    ans(atom_literal_identity_map)

    map_values(${clause_map})
    ans(tmp)
    set(literals)
    foreach(literal ${tmp})
      if("${literal}" MATCHES "^!?(.+)")
        list(APPEND literals ${CMAKE_MATCH_1})
      endif()
    endforeach()
    list_remove_duplicates(literals)

    foreach(literal ${literals})
        sequence_add(${atom_map} "${literal}")
        ans(ai)
        sequence_add(${literal_map} "${literal}")
        ans(li)
        sequence_add(${literal_map} "!${literal}")
        ans(li_neg)

        sequence_add(${literal_negated_map} false)
        sequence_add(${literal_negated_map} true)
        sequence_add(${atom_literal_map} ${li} ${li_neg})

        sequence_add(${literal_atom_map} ${ai})
        sequence_add(${literal_atom_map} ${ai})
        
        sequence_add(${atom_literal_negated_map} ${li_neg})
        sequence_add(${atom_literal_identity_map} ${li})

        sequence_add(${literal_inverse_map} ${li_neg})
        sequence_add(${literal_inverse_map} ${li})

        map_set(${literal_index_map} "${literal}" ${li})
        map_set(${literal_index_map} "!${literal}" ${li_neg})
        map_set(${atom_index_map} "${literal}" "${ai}")

    endforeach()

    map_new()
    ans(clause_atom_map)

    map_new()
    ans(clause_literal_map)

    map_new()
    ans(literal_clause_map)

    map_new()
    ans(atom_clause_map)

    foreach(ci ${clause_indices})
      map_tryget("${clause_map}" ${ci})
      ans(clause)
      map_set(${clause_atom_map} ${ci})
      map_set(${clause_literal_map} ${ci})
      foreach(literal ${clause})
        
        map_tryget(${literal_index_map} "${literal}")
        ans(li)

        map_tryget(${literal_atom_map} ${li})
        ans(ai)

        map_append_unique(${clause_atom_map} ${ci} ${ai})
        map_append_unique(${clause_literal_map} ${ci} ${li})
        map_append_unique(${literal_clause_map} ${li} ${ci})
        map_append_unique(${atom_clause_map} ${ai} ${ci})
      endforeach()
    endforeach()

    sequence_count(${clause_map})
    ans(c_n)
    math(EXPR c_last "${c_n} - 1")

    sequence_count(${literal_map})
    ans(l_n)
    math(EXPR l_last "${l_n} - 1")

    sequence_count(${atom_map})
    ans(a_n)
    math(EXPR a_last "${a_n} - 1")
    #json_print(${clause_map})

    map_capture_new(
      c_n
      c_last
      clause_map
      clause_atom_map
      clause_literal_map

      a_n
      a_last
      atom_map
      atom_clause_map
      atom_literal_map
      atom_literal_negated_map
      atom_literal_identity_map
      atom_index_map

      l_n 
      l_last
      literal_map
      literal_atom_map
      literal_inverse_map
      literal_negated_map
      literal_index_map
      literal_clause_map
    )
    ans(cnf)

    return_ref(cnf)

  endfunction()