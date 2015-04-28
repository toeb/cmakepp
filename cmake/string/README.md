## String Functions


`CMake` has one utility for working with string: `string()`. Inside of the jewel there is hidden lots of functionality which just has to be exposed correctly to the user.  I also wanted to expose this functionality in the `cmakepp` way of doing things (ie `return values`)

So I have created somewhat alot of functions which does things that you might need and alot of what you will probably never need - but feel good about because its there :)


### Function List


* [string_append_line_indented](#string_append_line_indented)
* [string_decode_delimited](#string_decode_delimited)
* [string_match](#string_match)
* [string_split_at_last](#string_split_at_last)
* [string_overlap](#string_overlap)
* [format](#format)
* [string_length](#string_length)
* [string_concat](#string_concat)
* [string_ends_with](#string_ends_with)
* [string_codes](#string_codes)
* [string_remove_beginning](#string_remove_beginning)
* [string_take_whitespace](#string_take_whitespace)
* [string_char_at](#string_char_at)
* [string_take_regex](#string_take_regex)
* [string_random](#string_random)
* [string_normalize_index](#string_normalize_index)
* [string_repeat](#string_repeat)
* [argument_escape](#argument_escape)
* [string_isnumeric](#string_isnumeric)
* [string_shorten](#string_shorten)
* [string_split_parts](#string_split_parts)
* [string_eval](#string_eval)
* [delimiters](#delimiters)
* [string_remove_ending](#string_remove_ending)
* [string_split_at_first](#string_split_at_first)
* [regex_search](#regex_search)
* [string_char_at_set](#string_char_at_set)
* [string_tolower](#string_tolower)
* [string_take_delimited](#string_take_delimited)
* [string_contains](#string_contains)
* [string_take_any_delimited](#string_take_any_delimited)
* [string_trim](#string_trim)
* [cmake_string_to_json](#cmake_string_to_json)
* [ascii_char](#ascii_char)
* [string_substring](#string_substring)
* [string_toupper](#string_toupper)
* [string_isempty](#string_isempty)
* [ascii_generate_table](#ascii_generate_table)
* [string_replace_first](#string_replace_first)
* [string_find](#string_find)
* [string_pad](#string_pad)
* [string_take_address](#string_take_address)
* [string_split](#string_split)
* [string_starts_with](#string_starts_with)
* [string_take](#string_take)
* [string_lines](#string_lines)
* [ascii_code](#ascii_code)
* [string_normalize](#string_normalize)
* [string_replace](#string_replace)
* [string_slice](#string_slice)
* [string_regex_escape](#string_regex_escape)
* [string_combine](#string_combine)
* [string_to_title](#string_to_title)
* [string_trim_to_difference](#string_trim_to_difference)

### Function Descriptions

## <a name="string_append_line_indented"></a> `string_append_line_indented`





## <a name="string_decode_delimited"></a> `string_decode_delimited`

 tries to parse a delimited string
 returns either the original or the parsed delimited string
 delimiters can be specified via varargs
 see also string_take_delimited




## <a name="string_match"></a> `string_match`





## <a name="string_split_at_last"></a> `string_split_at_last`





## <a name="string_overlap"></a> `string_overlap`





## <a name="format"></a> `format`

 [**`format(<template string>)-><string>`**](format.cmake)

 this function utilizes [`assign(...)`](#assign) to evaluate expressions which are enclosed in handlebars: `{` `}`
 

 *Examples*
 ```cmake
 # create a object
 obj("{a:1,b:[2,3,4,5,6],c:{d:3}}")
 ans(data)
 ## use format to print navigated expressiosn:
 format("{data.a} + {data.c.d} = {data.b[2]}") => "1 + 3 = 4"
 format("some numbers: {data.b[2:$]}") =>  "some numbers: 4;5;6"
 ...
 ```
 *Note:* You may not use ASCII-29 since it is used interally in this function. If you don't know what this means - don't worry
 





## <a name="string_length"></a> `string_length`





## <a name="string_concat"></a> `string_concat`





## <a name="string_ends_with"></a> `string_ends_with`





## <a name="string_codes"></a> `string_codes`





## <a name="string_remove_beginning"></a> `string_remove_beginning`





## <a name="string_take_whitespace"></a> `string_take_whitespace`





## <a name="string_char_at"></a> `string_char_at`

 [**`string_char_at(<index:int> <input:string>)-><char>`**](string_char_at.cmake)

 returns the character at the position specified. strings are indexed 0 based
 indices less than -1 are translated into length - |index|

 *Examples*
 





## <a name="string_take_regex"></a> `string_take_regex`





## <a name="string_random"></a> `string_random`





## <a name="string_normalize_index"></a> `string_normalize_index`





## <a name="string_repeat"></a> `string_repeat`





## <a name="argument_escape"></a> `argument_escape`





## <a name="string_isnumeric"></a> `string_isnumeric`

 returns true if the string is a integer (number)
 does not match non integers




## <a name="string_shorten"></a> `string_shorten`

 shortens the string to be at most max_length long




## <a name="string_split_parts"></a> `string_split_parts`





## <a name="string_eval"></a> `string_eval`

 evaluates the string <str> in the current scope
 this is done by macro variable expansion
 evaluates both ${} and @ style variables




## <a name="delimiters"></a> `delimiters`

 **`delimiters()->[delimiter_begin, delimiter_end]`**

 parses delimiters and retruns a list of length 2 containing the specified delimiters. 
 The usefullness of this function becomes apparent when you use [string_take_delimited](#string_take_delimited)
 





## <a name="string_remove_ending"></a> `string_remove_ending`





## <a name="string_split_at_first"></a> `string_split_at_first`





## <a name="regex_search"></a> `regex_search`





## <a name="string_char_at_set"></a> `string_char_at_set`

 `(<str:<string>> <index:<int>> <char:<string>>)-><string>`

 Sets the character at the specified position (index) to the input 'char'. 
 Indexing of strings starts at 0. Indices less than -1 are translated into "length - |index|"
 
 **Examples**





## <a name="string_tolower"></a> `string_tolower`





## <a name="string_take_delimited"></a> `string_take_delimited`

 if the beginning of the str_name is a delimited string
 the undelimited string is returned  and removed from str_name
 you can specify the delimiter (default is doublequote "")
 you can also specify begin and end delimiter 
 the delimiters may only be one char 
 the delimiters are removed from the result string
 escaped delimiters are unescaped




## <a name="string_contains"></a> `string_contains`





## <a name="string_take_any_delimited"></a> `string_take_any_delimited`

 takes a string which is delimited by any of the specified
 delimiters 
 string_take_any_delimited(<string&> <delimiters:<delimiter...>>)




## <a name="string_trim"></a> `string_trim`





## <a name="cmake_string_to_json"></a> `cmake_string_to_json`





## <a name="ascii_char"></a> `ascii_char`





## <a name="string_substring"></a> `string_substring`





## <a name="string_toupper"></a> `string_toupper`





## <a name="string_isempty"></a> `string_isempty`

 returns true if the given string is empty
 normally because cmake evals false, no,  
 which destroys tests for real emtpiness






## <a name="ascii_generate_table"></a> `ascii_generate_table`

 generates the ascii table and stores it in the global ascii_table variable  




## <a name="string_replace_first"></a> `string_replace_first`





## <a name="string_find"></a> `string_find`





## <a name="string_pad"></a> `string_pad`

 pads the specified string to be as long as specified
 if the string is longer then nothing is padded
 if no delimiter is specified than " " (space) is used
 if --prepend is specified the padding is inserted into front of string




## <a name="string_take_address"></a> `string_take_address`

 string_take_address

 takes an address from the string ref  




## <a name="string_split"></a> `string_split`





## <a name="string_starts_with"></a> `string_starts_with`





## <a name="string_take"></a> `string_take`





## <a name="string_lines"></a> `string_lines`





## <a name="ascii_code"></a> `ascii_code`





## <a name="string_normalize"></a> `string_normalize`





## <a name="string_replace"></a> `string_replace`





## <a name="string_slice"></a> `string_slice`





## <a name="string_regex_escape"></a> `string_regex_escape`





## <a name="string_combine"></a> `string_combine`

 combines the varargs into a string joining them with separator
 e.g. string_combine(, a b c) => "a,b,c"




## <a name="string_to_title"></a> `string_to_title`

 `(<str:<string>>)-><string>`

 Transforms the input string to title case.
 Tries to be smart and keeps some words small.

 **Examples**
  "the function string_totitle works"
  -> "The Function string_totitle Works"






## <a name="string_trim_to_difference"></a> `string_trim_to_difference`

 removes the beginning of the string that matches
 from ref lhs and ref rhs






