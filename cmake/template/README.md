# Templating 



`cmakepp`'s  templates allow you to generate content by mixing text with `CMake` code and executing it. There are many content generators out there for a host of different languages but none for `CMake`. I needed this functionality to generate the documentation for `cmakepp`. This tool is very simple but very mighty and can easily be used for generating source code files as the template syntax is compatible - as in 'does not interfere' - with `c++`, `cmake script`, `etc`. it is based around using `<%` and `%>` to indicate `CMake` script sections inside of a text file.


### Function List


* [template_compile_to](#template_compile_to)
* [template_eval](#template_eval)
* [template_generate](#template_generate)
* [template_guard](#template_guard)
* [template_output_ref](#template_output_ref)
* [template_read](#template_read)
* [template_run](#template_run)
* [template_write](#template_write)
* [template_write_data](#template_write_data)

### Function Descriptions

## <a name="template_compile_to"></a> `template_compile_to`

 `(<file path>)-><file path>`

 compiles the specified file (which is expected to end with `.in`) to the same path without the `.in`
 Uses `template_run` internally.
 returns the path to which it was compiled





## <a name="template_eval"></a> `template_eval`

 `(<string>)-><string>`

 





## <a name="template_generate"></a> `template_generate`

 `(<string>)-><cmake code>`

 *Description*
  parses the content for cmake expressions in  delimiters
  returns cmake code which can be evaluated


 **NOTE** *never use ascii 16 28 29 31*




## <a name="template_guard"></a> `template_guard`

 ()-><template output ref>

 fails if not executed inside of a template else returns the 
 template output ref





## <a name="template_output_ref"></a> `template_output_ref`

 ()-><template output ref>

 returns the output ref for the template





## <a name="template_read"></a> `template_read`

 (<file path>)-> <cmake code>
 
 reads the contents of the specified path and generates a template from it
 * return
   * the generated template code





## <a name="template_run"></a> `template_run`

  
 opens the specified template and runs it in its directory
 * returns 
    * the output of the template
 * scope
    * `pwd()` is set to the templates path
    * `${template_path}` is set to the path of the current template
    * `${template_dir}` is set to the directory of the current template
    * `${root_template_dir}` is set to the directory of the first template run
    * `${root_template_path}` is set to the path of the first template run
    * `${parent_template_dir}` is set to the calling templates dir 
    * `${parent_template_path}`  is set to the calling templates path
 
 




## <a name="template_write"></a> `template_write`

 (<string...>) -> <void>
 
 writes the specified string(s) to the templates output
 fails if not called inside a template





## <a name="template_write_data"></a> `template_write_data`

 (<structured data...>) -> <void>
 
 writes the serialized data to the templates output
 fails if not called inside a template







