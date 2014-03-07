function(CommandRunner)
	# field containing all command name => handler mappings
	map_create(commands)
	this_set(commands ${commands})

	# name for this command runner
	this_set(name "CommandRunner")

	## makes this object a functor
	# so it can be easily added to CommandRunner (recursively)
	obj_declarefunction(${__proto__} __call__)
	function(${__call__})		
		obj_callmember(${this} Run ${ARGN})
	endfunction()

	## Adds a commandhandler to this CommandRunner
	## this command_name must be unique
	## command_handler must be either a function or a functor
	obj_declarefunction(${__proto__} AddCommandHandler)
	function(${AddCommandHandler} command_name command_handler)
		#message("adding ${command_name}")
		map_has(${commands} has_command ${command_name})
		if( has_command)
			message(FATAL_ERROR "${name}> AddCommandHandler: command '${command_name}' was already added")
		endif()
		assert(NOT has_command)
		obj_isfunctor(is_functor "${command_handler}")
		is_function(is_function "${command_handler}")
		#message("AddCommandHandler ${command_handler}")
		if(NOT(is_functor OR is_function))
			message(FATAL_ERROR "${name}> AddCommandHandler: passed command_handler for '${command_name}' is not a function or functor: ${command_handler}")
		endif()
		assert(is_functor OR is_function)
		map_set(${commands} ${command_name} "${command_handler}")
		#message(STATUS "AddCommandHandler: adding command ${command_name}")
	endfunction()

	## the run method uses the first argument cmd to lookup a command handler
	## if the commandhandler is found it will be called
	obj_declarefunction(${__proto__} Run)
	function(${Run})
		set(args ${ARGN}) 
		set(cmd)
		## check if any argument was specifed and set the cmd to the first one
		if(args)
			list(GET args 0 cmd)
			#drop first argument
			list(REMOVE_AT args 0)
		endif()

		# if no command is set return error message
		if(NOT cmd)
			message("${name}> no command specified (try 'help')")
			return()
		endif()
		# try to get a handler for the command if none is found return error message
		map_tryget(${commands} handler ${cmd})
		if(NOT handler)
			message("${name}> could not find a command called '${cmd}' (try 'help')")
			return()
		endif()
		# invoke handler (depending on wether it is  afunctor or not )
		# todo:  only normal functions should be allowed
		# 		 (others can be handled via obj_bind*...)
		obj_isfunctor(is_functor ${handler})
		if(is_functor)
			obj_callobject(${handler} ${args})
			return()
		endif()
		call_function(${handler} ${args})
	endfunction()

	## the default help function.
	## prints out all declared commands of this handler
	obj_declarefunction(${__proto__} Help)
	function(${Help})
		# go through all keys and print them...
		map_keys(${commands} keys)
		message(STATUS "${name}> available commands for ${name}: ")
		foreach(key ${keys})
			message(STATUS "  ${key}")
		endforeach()
	endfunction()
	# register the command
	obj_callmember(${this} AddCommandHandler help ${Help})



endfunction()