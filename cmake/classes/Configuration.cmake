function(Configuration)
	this_inherit(CommandRunner)

	proto_declarefunction(AddConfigurationFilesRecurse )



	# create a field containing all configurations
	map_new()
  ans(configurations)
	this_set(configurations ${configurations})


	# recursively adds configuration files to the configuration object
	# starts with the given <path> and adds all coniguration files in <path> and its
	# paretn directories up to 
	function(${AddConfigurationFilesRecurse} path)
		# recursively add configuration files
		set(current_dir "${path}")
		while(true)
			get_filename_component(new_current_dir "${current_dir}" PATH)	
			# current dir is equal to new_current_dir when current_dir is root (recursion anchor)
			if("${new_current_dir}" STREQUAL "${current_dir}")
				break()
			endif()
			set(current_dir ${new_current_dir})
			# if cutil.config exists add it to configuration
			if(EXISTS "${current_dir}/cutil.config")
				string_normalize("${current_dir}/cutil.config")
				ans(name)
				obj_callmember(${this} AddConfigurationFile "${name}" "${current_dir}/cutil.config")
			endif()
		endwhile()
	endfunction()

	#  add a named configuration file to the configuration object
	# configuration files are searched in reverse order for 
	# configuration entries
	# 
	proto_declarefunction(AddConfigurationFile)
	function(${AddConfigurationFile} name config_file)
		set(config)
		message(DEBUG LEVEL 6 "Adding Configuration '${name}' @ ${config_file} ")
		map_navigate_set("this.configurations.${name}.file" "${config_file}")
		map_navigate_set("this.configurations.${name}.name" "${name}")
		obj_callmember(${this} Load)
	endfunction()

	# returns the configuration scope specified by SCOPE variable
	# if no SCOPE is specified  the most specialized scope is used
	# ie the last one added
	proto_declarefunction(GetScope)
	function(${GetScope} )
		this_import(configurations)
		cmake_parse_arguments("" "" "SCOPE" "" ${ARGN})
		set(config)
		if(NOT _SCOPE)
			map_keys(${configurations} )
			ans(keys)
			list_at( keys -1)
			ans(key)
			map_tryget(${configurations}  "${key}")
			ans(config)
		else()
			map_tryget(${configurations}  "${_SCOPE}")
			ans(config)
		endif()
		return_ref(config)
	endfunction()

	# set a configuration value in SCOPE. you can specify a navigation expression
	# if SCOPE is not specified the most specialized scope is used ie the last one
	# added
	# 
	proto_declarefunction(Set)
	function(${Set} navigation_expression value)	
		cmake_parse_arguments("" "" "SCOPE" "" ${ARGN})
		obj_callmember(${this} GetScope  SCOPE "${_SCOPE}")
		ans(config)
		if(NOT config)
			this_import(configurations)
			ref_print(${configurations})
			message(FATAL_ERROR "Configuration: could not find configuration scope '${_SCOPE}'")
		endif()

		map_get(${config}  "file")
		ans(file)
		map_get(${config}  "name")
		ans(name)
		if(EXISTS "${file}")
			file(READ "${file}" json)
			json_deserialize( ${json})
			ans(_config_object)
		endif()
		map_navigate_set("_config_object.${navigation_expression}" "${value}")
		
		map_navigate_set("configurations.${name}.config" ${_config_object})
		json_serialize( "${_config_object}" INDENTED)
		ans(json)
		file(WRITE "${file}" "${json}")
	endfunction()

	# get a configuration value from SCOPE if scope is not specified 
	# the most specialized scope is used
	proto_declarefunction(Get)
	function(${Get} navigation_expression)
		this_import(configurations)
		cmake_parse_arguments("" "" "SCOPE" "" ${ARGN})
		obj_callmember(${this} GetScope  SCOPE "${_SCOPE}")
		ans(config)
		if(NOT config)
			message(FATAL_ERROR "Configuration: could not find configuration scope")
		endif()

		map_keys(${configurations} )
		ans(keys)
		list(REVERSE keys)
		map_values(${configurations}  "${keys}" )
		ans(configs)
		if(NOT _SCOPE)
			list(GET keys 0 key)
			set(_SCOPE ${key})
		endif()
		set(found false)

		foreach(config ${configs})
			map_navigate(config_name "config.name")
			if(${found} OR ${config_name} STREQUAL "${_SCOPE}" )
				set(found true)
			endif()
			if(found)
				map_get(${config}  "file")
				ans(file)
				
				if(NOT EXISTS "${file}")
					return()
				endif()
				file(READ "${file}" json)
				json_deserialize( ${json})
				ans(_config_object)
				map_navigate(value "_config_object.${navigation_expression}")
				if(value)
					return_ref(value)
					break()
				endif()
			endif()
		endforeach()
		return()
	endfunction()

	proto_declarefunction(Save)
	function(${Save})
		map_keys(${configurations} )
		ans(keys)
		foreach(key ${keys})
			map_navigate(file "configurations.${key}.file")
			map_navigate(cfg "configurations.${key}.config")
			json_serialize( ${cfg} INDENTED)
			ans(json)
			file(WRITE ${file} "${json}")
		endforeach()
	endfunction()


	proto_declarefunction(Load)
	function(${Load})
		this_import(configurations)
		map_keys(${configurations} )
		ans(keys)
		set(configs)
		foreach(key ${keys})
			map_navigate(file "configurations.${key}.file")
			if(EXISTS  "${file}")
				file(READ ${file} json)
				json_deserialize( "${json}")
				ans(cfg)
				map_navigate_set("configurations.${key}.config" ${cfg})
				list(APPEND configs ${cfg})
			endif()
		endforeach()
		set(config)
		map_merge( ${configs})
		ans(config)
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
		map_keys(${configurations} )
		ans(keys)
		message("Current Config Scopes:")
		foreach(scope ${keys})
			message("  ${scope}")
		endforeach()
	endfunction()

	proto_declarefunction(SaveScope)
	function(${SaveScope} scope)
		map_tryget(${scope}  "file")
		ans(file)
		map_tryget(${scope}  config)
		ans(cfg)
		json_serialize( ${cfg})
		ans(res)
		file(WRITE "${file}" "${res}")
	endfunction()


	this_declarecalloperation(__call__)
	function(${__call__})
		cmake_parse_arguments("" "" "--scope" "" ${ARGN})
		set(scope)
		if( _--scope)
			set(scope SCOPE ${_--scope})
		endif()

		obj_callmember(${this} GetScope  ${scope})
		ans(__scope)
		map_tryget(${__scope}  config)
		ans(cfg)
		if(NOT cfg)
			map_new()
    	ans(cfg)
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