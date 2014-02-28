# a functor object can be imported as function ${target_name}
# this creates a function called ${target_name} which is bound to ${object}
# all arguments behind are passed along to import_function (e.g. REDEFINE, ONCE, ...)
function(obj_bindimportfunctor object target)
	obj_bindimportmember(${object} __call__ "${target}" ${ARGN})
endfunction()