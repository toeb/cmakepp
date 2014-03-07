

package_property(id "oo-cmake")
package_property(name "Object Oriented CMake lib")
package_property(description "adds prototypical object oriented functionality to CMake")
package_property(version "1.0")
package_property(license "MIT")
package_property(single_version true)
package_property(cmake_exports 
	cmake/debugging/debug_message.cmake
	cmake/core/*.cmake
	cmake/ref/ref_isvalid.cmake
	cmake/ref/ref_get.cmake
	cmake/string/replace_first.cmake
	cmake/include_once.cmake
	cmake/file/random_file.cmake
	cmake/function/function_signature_regex.cmake
	cmake/function/is_function_file.cmake	
	cmake/function/is_function_ref.cmake
	cmake/function/is_function_cmake.cmake
	cmake/function/is_function_string.cmake
	cmake/function/is_function.cmake
	cmake/function/load_function.cmake
	cmake/function/get_function_string.cmake
	cmake/function/get_function_lines.cmake
	cmake/function/get_function_signature.cmake
	cmake/function/save_function.cmake
	cmake/function/rename_function.cmake
	cmake/function/import_function_string.cmake
	cmake/function/parse_function.cmake
	cmake/function/inject_function.cmake
	cmake/function/import_function.cmake
	cmake/*.cmake
	cmake/string/*.cmake
	cmake/list/*.cmake
	cmake/stack/*.cmake
	cmake/file/*.cmake
	cmake/function/*.cmake
	cmake/map/*.cmake
	cmake/scope/*.cmake
	cmake/debugging/*.cmake
	cmake/object/this/*.cmake
	cmake/object/filebased/*.cmake
	cmake/object/*.cmake
	cmake/classes/*.cmake
	cmake/ref/*.cmake
	cmake/web/*.cmake

)
package_property(install_script)
package_property(cutil_main_script)
package_property(cutil_actions)


package_property(owner "Tobias Becker")
package_property(owner_email "becker.tobi@gmail.com")
package_property(authors "Tobias Becker")
package_property(homepage "http://github.org/toeb/oo-cmake")
package_property(date "17.02.2014 3:42")

