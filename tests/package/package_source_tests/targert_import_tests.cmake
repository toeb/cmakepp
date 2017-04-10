function(test)
    function(default defaultvalue)
        if(NOT ARGN)
            set(args ${ARGN})
            return_ref(args)
        else()
            return_ref(defaultValue)
        endif()
    endfunction()
    nuget(help pack  --passthru)

    ## returns the logs between / upto a specificrevision/version
    function(svm_logs)

    endfunction()

    function(release_notes)
        # get all log messages
        # parse log messages for release notes.
        # return  release not

        #maybe a format along:
        # feature> * 
        # bugfix>
        # improvement>
        # ....> *
    endfunction()



    package_source_pull_git("https://github.com/toeb/cmakepp.git?ref=v0.3.2-alpha")
    ans(packageHandle)
    json_print(${packageHandle})
    nuspec(${packageHandle})




return()

#     function(msbuild_property_sheet_create )

#         format("

# <Project ToolsVersion=\"4.0\" xmlns=\"http://schemas.microsoft.com/developer/msbuild/2003\">
#   <PropertyGroup Condition=\"'$(Force-Enable-cpprestsdk-v120-winapp-msvcstl-dyn-rt-dyn)' == '' And ('$(PlatformToolset)' != 'v120' Or '$(ApplicationType)' != 'Windows Store')\">
#     <Disable-cpprestsdk-v120-winapp-msvcstl-dyn-rt-dyn>true</Disable-cpprestsdk-v120-winapp-msvcstl-dyn-rt-dyn>
#   </PropertyGroup>
#   <PropertyGroup Condition=\"'$(Force-Disable-cpprestsdk-v120-winapp-msvcstl-dyn-rt-dyn)' != ''\">
#     <Disable-cpprestsdk-v120-winapp-msvcstl-dyn-rt-dyn>true</Disable-cpprestsdk-v120-winapp-msvcstl-dyn-rt-dyn>
#   </PropertyGroup>
#   <ItemDefinitionGroup Condition=\"'$(Disable-cpprestsdk-v120-winapp-msvcstl-dyn-rt-dyn)' == ''\">
#     <ClCompile>
#       <AdditionalOptions Condition=\"'$(PlatformToolset)'=='v140'\">/d2notypeopt %(AdditionalOptions)</AdditionalOptions>
#       <PreprocessorDefinitions Condition=\"'$(PlatformToolset)' == 'v120_xp'\">CPPREST_TARGET_XP;%(PreprocessorDefinitions)</PreprocessorDefinitions>
#       <!-- Workaround Visual Studio Android bug missing -funwind-tables if -fexceptions is specified. -->
#       <AdditionalOptions Condition=\"'$(PlatformToolset)' == 'Clang_3_6'\">-funwind-tables %(AdditionalOptions)</AdditionalOptions>
#     </ClCompile>
#     <Link>
#       <LibraryDependencies Condition=\"'$(PlatformToolset)' == 'Clang_3_6'\">m;%(LibraryDependencies)</LibraryDependencies>
#     </Link>
#   </ItemDefinitionGroup>
#   <ItemDefinitionGroup Condition=\"'$(Disable-cpprestsdk-v120-winapp-msvcstl-dyn-rt-dyn)' == ''\">
#     <Link>
#       <AdditionalDependencies Condition=\"'$(Configuration)' == 'Debug' And '$(Platform)' == 'arm'\">$(MSBuildThisFileDirectory)..\..\lib\native\v120\winapp\msvcstl\dyn\rt-dyn\arm\Debug\cpprest120d_app_2_9.lib;%(AdditionalDependencies)</AdditionalDependencies>
#       <AdditionalDependencies Condition=\"'$(Configuration)' == 'Release' And '$(Platform)' == 'arm'\">$(MSBuildThisFileDirectory)..\..\lib\native\v120\winapp\msvcstl\dyn\rt-dyn\arm\Release\cpprest120_app_2_9.lib;%(AdditionalDependencies)</AdditionalDependencies>
#       <AdditionalDependencies Condition=\"'$(Configuration)' == 'Debug' And '$(Platform)' == 'x64'\">$(MSBuildThisFileDirectory)..\..\lib\native\v120\winapp\msvcstl\dyn\rt-dyn\x64\Debug\cpprest120d_app_2_9.lib;%(AdditionalDependencies)</AdditionalDependencies>
#       <AdditionalDependencies Condition=\"'$(Configuration)' == 'Release' And '$(Platform)' == 'x64'\">$(MSBuildThisFileDirectory)..\..\lib\native\v120\winapp\msvcstl\dyn\rt-dyn\x64\Release\cpprest120_app_2_9.lib;%(AdditionalDependencies)</AdditionalDependencies>
#       <AdditionalDependencies Condition=\"'$(Configuration)' == 'Debug' And ('$(Platform)' == 'Win32' Or '$(Platform)' == 'x86')\">$(MSBuildThisFileDirectory)..\..\lib\native\v120\winapp\msvcstl\dyn\rt-dyn\x86\Debug\cpprest120d_app_2_9.lib;%(AdditionalDependencies)</AdditionalDependencies>
#       <AdditionalDependencies Condition=\"'$(Configuration)' == 'Release' And ('$(Platform)' == 'Win32' Or '$(Platform)' == 'x86')\">$(MSBuildThisFileDirectory)..\..\lib\native\v120\winapp\msvcstl\dyn\rt-dyn\x86\Release\cpprest120_app_2_9.lib;%(AdditionalDependencies)</AdditionalDependencies>
#     </Link>
#     <ClCompile>
#       <AdditionalIncludeDirectories>$(MSBuildThisFileDirectory)include;%(AdditionalIncludeDirectories)</AdditionalIncludeDirectories>
#     </ClCompile>
#   </ItemDefinitionGroup>
#   <ItemGroup Condition=\"'$(Configuration)' == 'Debug' And '$(Platform)' == 'arm' And '$(Disable-cpprestsdk-v120-winapp-msvcstl-dyn-rt-dyn)' == ''\">
#     <ReferenceCopyLocalPaths Include=\"$(MSBuildThisFileDirectory)..\..\lib\native\v120\winapp\msvcstl\dyn\rt-dyn\arm\Debug\cpprest120d_app_2_9.dll\" />
#     <ReferenceCopyLocalPaths Include=\"$(MSBuildThisFileDirectory)..\..\lib\native\v120\winapp\msvcstl\dyn\rt-dyn\arm\Debug\cpprest120d_app_2_9.pdb\" />
#   </ItemGroup>
#   <ItemGroup Condition=\"'$(Configuration)' == 'Release' And '$(Platform)' == 'arm' And '$(Disable-cpprestsdk-v120-winapp-msvcstl-dyn-rt-dyn)' == ''\">
#     <ReferenceCopyLocalPaths Include=\"$(MSBuildThisFileDirectory)..\..\lib\native\v120\winapp\msvcstl\dyn\rt-dyn\arm\Release\cpprest120_app_2_9.dll\" />
#     <ReferenceCopyLocalPaths Include=\"$(MSBuildThisFileDirectory)..\..\lib\native\v120\winapp\msvcstl\dyn\rt-dyn\arm\Release\cpprest120_app_2_9.pdb\" />
#   </ItemGroup>
#   <ItemGroup Condition=\"'$(Configuration)' == 'Debug' And '$(Platform)' == 'x64' And '$(Disable-cpprestsdk-v120-winapp-msvcstl-dyn-rt-dyn)' == ''\">
#     <ReferenceCopyLocalPaths Include=\"$(MSBuildThisFileDirectory)..\..\lib\native\v120\winapp\msvcstl\dyn\rt-dyn\x64\Debug\cpprest120d_app_2_9.dll\" />
#     <ReferenceCopyLocalPaths Include=\"$(MSBuildThisFileDirectory)..\..\lib\native\v120\winapp\msvcstl\dyn\rt-dyn\x64\Debug\cpprest120d_app_2_9.pdb\" />
#   </ItemGroup>
#   <ItemGroup Condition=\"'$(Configuration)' == 'Release' And '$(Platform)' == 'x64' And '$(Disable-cpprestsdk-v120-winapp-msvcstl-dyn-rt-dyn)' == ''\">
#     <ReferenceCopyLocalPaths Include=\"$(MSBuildThisFileDirectory)..\..\lib\native\v120\winapp\msvcstl\dyn\rt-dyn\x64\Release\cpprest120_app_2_9.dll\" />
#     <ReferenceCopyLocalPaths Include=\"$(MSBuildThisFileDirectory)..\..\lib\native\v120\winapp\msvcstl\dyn\rt-dyn\x64\Release\cpprest120_app_2_9.pdb\" />
#   </ItemGroup>
#   <ItemGroup Condition=\"'$(Configuration)' == 'Debug' And ('$(Platform)' == 'Win32' Or '$(Platform)' == 'x86') And '$(Disable-cpprestsdk-v120-winapp-msvcstl-dyn-rt-dyn)' == ''\">
#     <ReferenceCopyLocalPaths Include=\"$(MSBuildThisFileDirectory)..\..\lib\native\v120\winapp\msvcstl\dyn\rt-dyn\x86\Debug\cpprest120d_app_2_9.dll\" />
#     <ReferenceCopyLocalPaths Include=\"$(MSBuildThisFileDirectory)..\..\lib\native\v120\winapp\msvcstl\dyn\rt-dyn\x86\Debug\cpprest120d_app_2_9.pdb\" />
#   </ItemGroup>
#   <ItemGroup Condition=\"'$(Configuration)' == 'Release' And ('$(Platform)' == 'Win32' Or '$(Platform)' == 'x86') And '$(Disable-cpprestsdk-v120-winapp-msvcstl-dyn-rt-dyn)' == ''\">
#     <ReferenceCopyLocalPaths Include=\"$(MSBuildThisFileDirectory)..\..\lib\native\v120\winapp\msvcstl\dyn\rt-dyn\x86\Release\cpprest120_app_2_9.dll\" />
#     <ReferenceCopyLocalPaths Include=\"$(MSBuildThisFileDirectory)..\..\lib\native\v120\winapp\msvcstl\dyn\rt-dyn\x86\Release\cpprest120_app_2_9.pdb\" />
#   </ItemGroup>
# </Project>
# ")

#     endfunction()

#  todo - make output automatically generate cmake input...
#   data("{
#     linkage:'SHARED' | 'STATIC' | 'OBJECT',
#     include_dirs:'' | [],
#     library_dirs:'' | [],
#     libs:['']
#     definitions:'',
#     options:''
#     DEBUG:'',
#     CONFIG:'',
#     RELEASE:'',
#     MINSIZEREL:''

#     }")
#   ans(target_descriptor)
# json_print(${target_descriptor})
#   function(target_import targetName targetDescriptor )


#     set(targetName)
#     set(targetKind SHARED) # or STATIC OR NON? or OBJECT?
#     set(includeDirs)
#     set(implib)
#     set(location)

#     map_import_properties_all(${targetDescriptor})


#     add_library("${targetName}" "${linkage}" IMPORTED GLOBAL)


#     function(target_config_set targetName targetConfig propertyName)
#         if(NOT "${targetConfig}_" STREQUAL "_")
#             string_toupper("${targetConfig}")
#             ans(targetConfig)


#             list_contains(CMAKE_CONFIGURATION_TYPES ${targetConfig})
#             ans(isvalid)
#             if(NOT isvalid)
#                 message(FATAL_ERROR "cannot set target property '${propertyName}' for config '${targetConfig}' because this type of configuration does not exist  ")
#                 return(false)
#             endif()

#             set(propertyName ${propertyName}_${targetConfig}")
#         endif()
#         target_set("${targetName}" "${propertyName}" ${ARGN})
#         return(true)
#     endfunction()




#     foreach(configType ${CMAKE_CONFIGURATION_TYPES} "")
#         target_config_set("${targetName}" "${configType}" IMPORTED_LOCATION)
#         target_config_set("${targetName}" "${configType}" IMPORTED_IMPLIB)
#         target_config_set("${targetName}" "${configType}" INTERFACE_INCLUDE_DIRECTORIES)
#         target_config_set("${targetName}" "${configType}" IMPORTED_LOCATION)
#     endforeach()


#     # install()  for binary files 
#     # copy to output directory?
#   endfunction()



# return()

endfunction()