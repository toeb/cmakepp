
function(semver_constraint_evaluate result  constraint version)
  semver_constraint_compile(compiled_constraint constraint_elements "${constraint}")
  semver_constraint_compiled_evaluate(res  "${compiled_constraint}" "${constraint_elements}" "${version}")
  set(${result} ${res} PARENT_SCOPE)  
endfunction()