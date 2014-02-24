

package_property(package_id "oo-cmake")
package_property(package_name "Object Oriented CMake lib")
package_property(package_description "adds prototypical object oriented functionality to CMake")
package_property(package_version "1.0")
package_property(package_license "MIT")
package_property(package_single_version true)
package_property(package_cmake_exports 
	scripts/debugging/debug_message.cmake
	scripts/core/*
	scripts/string/replace_first.cmake
	scripts/include_once.cmake
	#scripts/core/return_value.cmake
	#scripts/core/return_prefixed_value.cmake
	scripts/file/random_file.cmake
	#scripts/core/make_guid.cmake
	scripts/function/function_signature_regex.cmake
	scripts/function/is_function_file.cmake
	scripts/function/is_function_ref.cmake
	scripts/function/is_function_cmake.cmake
	scripts/function/is_function_string.cmake
	scripts/function/is_function.cmake
	scripts/function/load_function.cmake
	scripts/function/get_function_string.cmake
	scripts/function/get_function_lines.cmake
	scripts/function/get_function_signature.cmake
	scripts/function/save_function.cmake
	scripts/function/rename_function.cmake
	scripts/function/import_function_string.cmake
	scripts/function/parse_function.cmake
	scripts/function/inject_function.cmake
	scripts/function/import_function.cmake
	scripts/*
	scripts/string/*
	scripts/list/*
	scripts/stack/*
	scripts/file/*
	scripts/function/*
	scripts/map/*
	scripts/debugging/*
	scripts/object/this/* 
	scripts/object/filebased/*  
	scripts/object/*
	classes/*
	scripts/*
)
package_property(package_install_script)
package_property(package_cutil_main_script)
package_property(package_cutil_actions)


package_property(package_owner "Tobias Becker")
package_property(package_owner_email "becker.tobi@gmail.com")
package_property(package_authors "Tobias Becker")
package_property(package_homepage "http://github.org/toeb/oo-cmake")
package_property(package_date "17.02.2014 3:42")

