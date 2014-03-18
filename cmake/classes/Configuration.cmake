function(Configuration)
	this_inherit(CommandRunner)

	# create a field containing all configurations
	map_create(configurations)
	this_set(configurations ${configurations})

	#  add a named configuration file to the configuration object
	# configuration files are searched in reverse order for 
	# configuration entries
	# 
	proto_declarefunction(AddConfigurationFile)
	function(${AddConfigurationFile} name config_file)
		set(config)
		map_navigate_set("configurations.${name}.file" "${config_file}")
		map_navigate_set("configurations.${name}.name" "${name}")
		obj_callmember(${this} Load)
	endfunction()

	# returns the configuration scope specified by SCOPE variable
	# if no SCOPE is specified  the most specialized scope is used
	# ie the last one added
	proto_declarefunction(GetScope)
	function(${GetScope} result)
		cmake_parse_arguments("" "" "SCOPE" "" ${ARGN})
		set(config)
		if(NOT _SCOPE)
			map_keys(${configurations} keys)
			list_at(key keys -1)
			map_tryget(${configurations} config "${key}")
		else()
			map_tryget(${configurations} config "${_SCOPE}")
		endif()
		set(${result} ${config} PARENT_SCOPE)
	endfunction()

	# set a configuration value in SCOPE. you can specify a navigation expression
	# if SCOPE is not specified the most specialized scope is used ie the last one
	# added
	# 
	proto_declarefunction(Set)
	function(${Set} navigation_expression value)	
		cmake_parse_arguments("" "" "SCOPE" "" ${ARGN})
		obj_callmember(${this} GetScope config SCOPE "${_SCOPE}")
		if(NOT config)
			message(FATAL_ERROR "Configuration: could not find configuration scope")
		endif()

		map_get(${config} file "file")
		map_get(${config} name "name")
		if(EXISTS "${file}")
			file(READ "${file}" json)
			json_deserialize(_config_object ${json})
		endif()
		map_navigate_set("_config_object.${navigation_expression}" "${value}")
		
		map_navigate_set("configurations.${name}.config" ${_config_object})
		json_serialize(json "${_config_object}" INDENTED)
		file(WRITE "${file}" "${json}")
	endfunction()

	# get a configuration value from SCOPE if scope is not specified 
	# the most specialized scope is used
	proto_declarefunction(Get)
	function(${Get} result navigation_expression)
		cmake_parse_arguments("" "" "SCOPE" "" ${ARGN})
		obj_callmember(${this} GetScope config SCOPE "${_SCOPE}")
		if(NOT config)
			message(FATAL_ERROR "Configuration: could not find configuration scope")
		endif()

		map_keys(${configurations} keys)
		list(REVERSE keys)
		map_values(${configurations} configs "${keys}" )
		if(NOT _SCOPE)
			list(GET keys 0 key)
			set(_SCOPE ${key})
		endif()
		set(found false)
		set(${result} "" PARENT_SCOPE)
		foreach(config ${configs})
			map_navigate(config_name "config.name")
			if(${found} OR ${config_name} STREQUAL "${_SCOPE}" )
				set(found true)
			endif()
			if(found)
				map_get(${config} file "file")
				
				if(NOT EXISTS "${file}")
					return_value()
				endif()
				file(READ "${file}" json)
				json_deserialize(_config_object ${json})
				map_navigate(value "_config_object.${navigation_expression}")
				if(value)
					set(${result} ${value} PARENT_SCOPE)
					break()
				endif()
			endif()
		endforeach()
	endfunction()

	proto_declarefunction(Save)
	function(${Save})
		map_keys(${configurations} keys)
		foreach(key ${keys})
			map_navigate(file "configurations.${key}.file")
			map_navigate(cfg "configurations.${key}.config")
			json_serialize(json ${cfg} INDENTED)
			file(WRITE ${file} "${json}")
		endforeach()
	endfunction()


	proto_declarefunction(Load)
	function(${Load})
		map_keys(${configurations} keys)
		set(configs)
		foreach(key ${keys})
			map_navigate(file "configurations.${key}.file")
			if(EXISTS  "${file}")
				file(READ ${file} json)
				json_deserialize(cfg "${json}")
				map_navigate_set("configurations.${key}.config" ${cfg})
				list(APPEND configs ${cfg})
			endif()
		endforeach()
		set(config)
		map_merge(config ${configs})
		this_set(configuration ${config})
		#ref_print(${config})
	endfunction()


	proto_declarefunction(GetCommand)
	function(${GetCommand})
		cmake_parse_arguments("" "--all;--json" "--scope" "" ${ARGN})
		obj_callmember(${this} Load)
		

		if(_--scope AND _--all)
			set(cfg)
			map_navigate(cfg "configurations.${_--scope}.config")
			if(cfg)
				ref_print(${cfg})
			else()
				message("no configuration found")
			endif()
			return()
		endif()

		if(_--all)
			if(configuration)
				ref_print(${configuration})
			else()
				message("no configuration found")
			endif()
			return()
		endif()

		if(_--scope)
			map_navigate(res "configurations.${_--scope}.config.${ARGN}")
			ref_print(${res})
		else()
			map_navigate(res "configuration.${ARGN}")
			ref_print(${res})
		endif()

	endfunction()


	proto_declarefunction(SetCommand)
	function(${SetCommand})
		cmake_parse_arguments("" "" "--scope" "" ${ARGN})
		set(scope)
		if( _--scope)
			set(scope SCOPE ${_--scope})
		endif()
		if(NOT _UNPARSED_ARGUMENTS)
			message("Configuration: not value to be set")
			return()
		endif()
		obj_callmember(${this} Set ${_UNPARSED_ARGUMENTS} ${scope})
	endfunction()

	proto_declarefunction(PrintScopes)
	function(${PrintScopes})
		map_keys(${configurations} keys)
		message("Current Config Scopes:")
		foreach(scope ${keys})
			message("  ${scope}")
		endforeach()
	endfunction()

	proto_declarefunction(SaveScope)
	function(${SaveScope} scope)
		map_tryget(${scope} file "file")
		map_tryget(${scope} cfg config)
		json_serialize(res ${cfg})
		file(WRITE "${file}" "${res}")
	endfunction()



	proto_declarefunction(__call__)
	function(${__call__})
		cmake_parse_arguments("" "" "--scope" "" ${ARGN})
		set(scope)
		if( _--scope)
			set(scope SCOPE ${_--scope})
		endif()

		obj_callmember(${this} GetScope __scope ${scope})
		map_tryget(${__scope} cfg config)
		if(NOT cfg)
			map_create(cfg)
			map_set(${__scope} config ${cfg})
		endif()

		if(NOT _UNPARSED_ARGUMENTS)

			set(cfg ${configuration})	
		else()
			list(LENGTH _UNPARSED_ARGUMENTS len)
			if(len EQUAL 1)
				set(cfg ${configuration})
			endif()
		endif()

		set(_UNPARSED_ARGUMENTS "cfg.${_UNPARSED_ARGUMENTS}")

		map_edit(${_UNPARSED_ARGUMENTS} --print)
		obj_callmember(${this} SaveScope ${__scope})
	endfunction()



#	obj_bind(bound_function ${this} ${Edit})
#	obj_callmember(${this} AddCommandHandler edit ${bound_function})

#	obj_bind(bound_function ${this} ${GetCommand})
#	obj_callmember(${this} AddCommandHandler get ${bound_function})

#	obj_bind(bound_function ${this} ${SetCommand})
#	obj_callmember(${this} AddCommandHandler set ${bound_function})

#	obj_bind(bound_function ${this} ${PrintScopes})
#	obj_callmember(${this} AddCommandHandler scopes ${bound_function})


endfunction()