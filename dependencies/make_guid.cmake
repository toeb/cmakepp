
#creates a unique id
function(make_guid out_id)
string(RANDOM LENGTH 10 id)
set(${out_id} ${id} PARENT_SCOPE)
endfunction()
