function(test)

 todo - make output automatically generate cmake input...
  data("{
    linkage:'SHARED' | 'STATIC' | 'OBJECT',
    include_dirs:'' | [],
    library_dirs:'' | [],
    libs:['']
    definitions:'',
    options:''
    DEBUG:'',
    CONFIG:'',
    RELEASE:'',
    MINSIZEREL:''

    }")
  ans(target_descriptor)
json_print(${target_descriptor})
  function(target_import targetName targetDescriptor )


    set(targetName)
    set(targetKind SHARED) # or STATIC OR NON? or OBJECT?
    set(includeDirs)
    set(implib)
    set(location)

    map_import_properties_all(${targetDescriptor})


    add_library("${targetName}" "${linkage}" IMPORTED GLOBAL)


    function(target_config_set targetName targetConfig propertyName)
        if(NOT "${targetConfig}_" STREQUAL "_")
            string_toupper("${targetConfig}")
            ans(targetConfig)


            list_contains(CMAKE_CONFIGURATION_TYPES ${targetConfig})
            ans(isvalid)
            if(NOT isvalid)
                message(FATAL_ERROR "cannot set target property '${propertyName}' for config '${targetConfig}' because this type of configuration does not exist  ")
                return(false)
            endif()

            set(propertyName ${propertyName}_${targetConfig}")
        endif()
        target_set("${targetName}" "${propertyName}" ${ARGN})
        return(true)
    endfunction()




    foreach(configType ${CMAKE_CONFIGURATION_TYPES} "")
        target_config_set("${targetName}" "${configType}" IMPORTED_LOCATION)
        target_config_set("${targetName}" "${configType}" IMPORTED_IMPLIB)
        target_config_set("${targetName}" "${configType}" INTERFACE_INCLUDE_DIRECTORIES)
        target_config_set("${targetName}" "${configType}" IMPORTED_LOCATION)
    endforeach()


    # install()  for binary files 
    # copy to output directory?
  endfunction()



return()

endfunction()