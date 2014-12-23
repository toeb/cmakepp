function(CommandRunner)
	# field containing all command name => handler mappings
	map_new()
  ans(commands)
	this_set(commands ${commands})

	# name for this command runner
	this_set(name "CommandRunner")

	this_declare_call(callfunc)
	function(${callfunc})		
		call(this.Run(${ARGN}))
		return_ans()
	endfunction()

	## Adds a commandhandler to this CommandRunner
	## this command_name must be unique
	## command_handler must be either a function or a functor
	proto_declarefunction(AddCommandHandler)
	function(${AddCommandHandler} command_name command_handler)
		this_import(commands)
		#message("adding ${command_name}")
		map_has(${commands}  ${command_name})
		ans(has_command)
		if( has_command)
			#ref_print(${commands})
		#	message(FATAL_ERROR "${name}> AddCommandHandler: command '${command_name}' was already added")
		endif()
		

		map_set(${commands} ${command_name} "${command_handler}")
	endfunction()

	## the run method uses the first argument cmd to lookup a command handler
	## if the commandhandler is found it will be called
	proto_declarefunction(Run)
	function(${Run})
		this_import(commands)

		set(args ${ARGN}) 
		set(cmd)
		## check if any argument was specifed and set the cmd to the first one
		if(args)
			list_pop_front(args)
			ans(cmd)
		endif()

		# if no command is set return error message
		if(NOT cmd)
			message("${name}> no command specified (try 'help')")
			return()
		endif()
		# try to get a handler for the command if none is found return error message
		map_tryget("${commands}"  "${cmd}")
		ans(handler)
		if(NOT handler)		
			message("${name}> could not find a command called '${cmd}' (try 'help')")
			return()
		endif()

		call("${handler}" (${args}))
		return_ans()
	endfunction()

	## the default help function.
	## prints out all declared commands of this handler
	proto_declarefunction(Help)
	function(${Help})
		# go through all keys and print them...
		map_keys(${commands} )
		ans(keys)
		message(STATUS "${name}> available commands for ${name}: ")
		foreach(key ${keys})
			message(STATUS "  ${key}")
		endforeach()
	endfunction()
	# register the command
	obj_member_call(${this} AddCommandHandler help ${Help})



endfunction()