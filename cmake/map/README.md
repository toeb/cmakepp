## Maps - Structured Data in CMake



Maps are very versatile and are missing dearly from CMake in my opinion. Maps are references as is standard in many languages. They are signified by having properties which are adressed by keys and can take any value.

Due to the "variable variable" system (ie names of variables are string which can be generated from other variables) it is very easy to implement the map system. Under the hood a value is mapped by calling `address_set(${map}.${key})`.  



### Function List


* [is_map](#is_map)
* [map_append](#map_append)
* [map_append_string](#map_append_string)
* [map_append_unique](#map_append_unique)
* [map_delete](#map_delete)
* [map_duplicate](#map_duplicate)
* [map_get](#map_get)
* [map_get_special](#map_get_special)
* [map_has](#map_has)
* [map_keys](#map_keys)
* [map_new](#map_new)
* [map_remove](#map_remove)
* [map_remove_item](#map_remove_item)
* [map_set](#map_set)
* [map_set_hidden](#map_set_hidden)
* [map_set_special](#map_set_special)
* [map_tryget](#map_tryget)
* [dfs](#dfs)
* [dfs_callback](#dfs_callback)
* [list_match](#list_match)
* [map_all_paths](#map_all_paths)
* [map_at](#map_at)
* [map_capture](#map_capture)
* [map_capture_new](#map_capture_new)
* [map_clear](#map_clear)
* [map_copy_shallow](#map_copy_shallow)
* [map_count](#map_count)
* [map_defaults](#map_defaults)
* [map_ensure](#map_ensure)
* [map_extract](#map_extract)
* [map_fill](#map_fill)
* [map_flatten](#map_flatten)
* [map_from_keyvaluelist](#map_from_keyvaluelist)
* [map_get_default](#map_get_default)
* [map_get_map](#map_get_map)
* [map_has_all](#map_has_all)
* [map_has_any](#map_has_any)
* [map_invert](#map_invert)
* [map_isempty](#map_isempty)
* [map_keys_append](#map_keys_append)
* [map_keys_clear](#map_keys_clear)
* [map_keys_remove](#map_keys_remove)
* [map_keys_set](#map_keys_set)
* [map_keys_sort](#map_keys_sort)
* [map_key_at](#map_key_at)
* [map_match](#map_match)
* [map_matches](#map_matches)
* [map_match_properties](#map_match_properties)
* [map_omit](#map_omit)
* [map_omit_regex](#map_omit_regex)
* [map_overwrite](#map_overwrite)
* [map_pairs](#map_pairs)
* [test](#test)
* [map_path_get](#map_path_get)
* [map_path_set](#map_path_set)
* [map_peek_back](#map_peek_back)
* [map_peek_front](#map_peek_front)
* [map_pick](#map_pick)
* [map_pick_regex](#map_pick_regex)
* [map_pop_back](#map_pop_back)
* [map_pop_front](#map_pop_front)
* [map_promote](#map_promote)
* [map_property_length](#map_property_length)
* [map_push_back](#map_push_back)
* [map_push_front](#map_push_front)
* [map_rename](#map_rename)
* [map_set_default](#map_set_default)
* [map_to_keyvaluelist](#map_to_keyvaluelist)
* [map_to_valuelist](#map_to_valuelist)
* [map_unpack](#map_unpack)
* [map_values](#map_values)
* [mm](#mm)
* [map_iterator](#map_iterator)
* [map_iterator_break](#map_iterator_break)
* [map_iterator_next](#map_iterator_next)
* [map_import_properties](#map_import_properties)
* [map_match_obj](#map_match_obj)
* [map_clone](#map_clone)
* [map_clone_deep](#map_clone_deep)
* [map_clone_shallow](#map_clone_shallow)
* [map_equal](#map_equal)
* [map_equal_obj](#map_equal_obj)
* [map_foreach](#map_foreach)
* [map_issubsetof](#map_issubsetof)
* [map_merge](#map_merge)
* [map_union](#map_union)

### Function Descriptions

## <a name="is_map"></a> `is_map`





## <a name="map_append"></a> `map_append`

 appends a value to the end of a map entry




## <a name="map_append_string"></a> `map_append_string`





## <a name="map_append_unique"></a> `map_append_unique`





## <a name="map_delete"></a> `map_delete`





## <a name="map_duplicate"></a> `map_duplicate`





## <a name="map_get"></a> `map_get`





## <a name="map_get_special"></a> `map_get_special`





## <a name="map_has"></a> `map_has`





## <a name="map_keys"></a> `map_keys`

 returns all keys for the specified map




## <a name="map_new"></a> `map_new`





## <a name="map_remove"></a> `map_remove`





## <a name="map_remove_item"></a> `map_remove_item`





## <a name="map_set"></a> `map_set`

 set a value in the map




## <a name="map_set_hidden"></a> `map_set_hidden`





## <a name="map_set_special"></a> `map_set_special`





## <a name="map_tryget"></a> `map_tryget`

 tries to get the value map[key] and returns NOTFOUND if
 it is not found




## <a name="dfs"></a> `dfs`

 iterates a the graph with root nodes in ${ARGN}
 in depth first order
 expand must consider cycles




## <a name="dfs_callback"></a> `dfs_callback`

 emits events parsing a list of map type elements 
 expects a callback function that takes the event type string as a first argument
 follwowing events are called (available context variables are listed as subelements: 
 value
   - list_length (may be 0 or 1 which is good for a null check)
   - content_length (contains the length of the content)
   - node (contains the value)
 list_begin
   - list_length (number of elements the list contains)
   - content_length (accumulated length of list elements + semicolon separators)
   - node (contains all values of the lsit)
 list_end
   - list_length(number of elements in list)
   - node (whole list)
   - list_char_length (length of list content)
   - content_length (accumulated length of list elements + semicolon separators)
 list_element_begin
   - list_length(number of elements in list)
   - node (whole list)
   - list_char_length (length of list content)
   - content_length (accumulated length of list elements + semicolon separators)
   - list_element (contains current list element)
   - list_element_index (contains current index )   
 list_element_end
   - list_length(number of elements in list)
   - node (whole list)
   - list_char_length (length of list content)
   - content_length (accumulated length of list elements + semicolon separators)
   - list_element (contains current list element)
   - list_element_index (contains current index )
 visited_reference
   - node (contains ref to revisited map)
 unvisited_reference
   - node (contains ref to unvisited map)
 map_begin
   - node( contains ref to map)
   - map_keys (contains all keys of map)
   - map_length (contains number of keys of map)
 map_end
   - node( contains ref to map)
   - map_keys (contains all keys of map)
   - map_length (contains number of keys of map)
 map_element_begin
   - node( contains ref to map)
   - map_keys (contains all keys of map)
   - map_length (contains number of keys of map)
   - map_element_key (current key)
   - map_element_value (current value)
   - map_element_index (current index)
 map_element_end
   - node( contains ref to map)
   - map_keys (contains all keys of map)
   - map_length (contains number of keys of map)
   - map_element_key (current key)
   - map_element_value (current value)
   - map_element_index (current index)




## <a name="list_match"></a> `list_match`

 matches the object list 




## <a name="map_all_paths"></a> `map_all_paths`

 returns all possible paths for the map
 (currently crashing on cycles cycles)
 todo: implement




## <a name="map_at"></a> `map_at`





## <a name="map_capture"></a> `map_capture`





## <a name="map_capture_new"></a> `map_capture_new`





## <a name="map_clear"></a> `map_clear`

 removes all properties from map




## <a name="map_copy_shallow"></a> `map_copy_shallow`

 copies the values of the source map into the target map by assignment
 (shallow copy)




## <a name="map_count"></a> `map_count`





## <a name="map_defaults"></a> `map_defaults`

 sets all undefined properties of map to the default value




## <a name="map_ensure"></a> `map_ensure`

 ensures that the specified vars are a map
 parsing structured data if necessary




## <a name="map_extract"></a> `map_extract`





## <a name="map_fill"></a> `map_fill`





## <a name="map_flatten"></a> `map_flatten`





## <a name="map_from_keyvaluelist"></a> `map_from_keyvaluelist`

 adds the keyvalues list to the map (if not map specified created one)




## <a name="map_get_default"></a> `map_get_default`





## <a name="map_get_map"></a> `map_get_map`





## <a name="map_has_all"></a> `map_has_all`

 returns true if map has all keys specified
as varargs




## <a name="map_has_any"></a> `map_has_any`

 returns true if map has any of the keys
 specified as varargs




## <a name="map_invert"></a> `map_invert`

 returns a copy of map with key values inverted
 only works correctly for bijective maps




## <a name="map_isempty"></a> `map_isempty`





## <a name="map_keys_append"></a> `map_keys_append`





## <a name="map_keys_clear"></a> `map_keys_clear`





## <a name="map_keys_remove"></a> `map_keys_remove`





## <a name="map_keys_set"></a> `map_keys_set`





## <a name="map_keys_sort"></a> `map_keys_sort`





## <a name="map_key_at"></a> `map_key_at`





## <a name="map_match"></a> `map_match`





## <a name="map_matches"></a> `map_matches`

 returns a function which returns true of all 




## <a name="map_match_properties"></a> `map_match_properties`

 returns true if map's properties match all properties of attrs




## <a name="map_omit"></a> `map_omit`

 returns a copy of map without the specified keys (argn)




## <a name="map_omit_regex"></a> `map_omit_regex`

 returns a map with all properties except those matched by any of the specified regexes




## <a name="map_overwrite"></a> `map_overwrite`





## <a name="map_pairs"></a> `map_pairs`

 returns a list key;value;key;value;...
 only works if key and value are not lists (ie do not contain ;)




## <a name="test"></a> `test`





## <a name="map_path_get"></a> `map_path_get`

 returns the value at the specified path (path is specified as path fragment list)
 e.g. map = {a:{b:{c:{d:{e:3}}}}}
 map_path_get(${map} a b c d e)
 returns 3
 this function is somewhat faster than map_navigate()




## <a name="map_path_set"></a> `map_path_set`

 todo implement




## <a name="map_peek_back"></a> `map_peek_back`





## <a name="map_peek_front"></a> `map_peek_front`





## <a name="map_pick"></a> `map_pick`

 returns a copy of map returning only the whitelisted keys




## <a name="map_pick_regex"></a> `map_pick_regex`

 returns a map containing all properties whose keys were matched by any of the specified regexes




## <a name="map_pop_back"></a> `map_pop_back`





## <a name="map_pop_front"></a> `map_pop_front`





## <a name="map_promote"></a> `map_promote`





## <a name="map_property_length"></a> `map_property_length`





## <a name="map_push_back"></a> `map_push_back`





## <a name="map_push_front"></a> `map_push_front`





## <a name="map_rename"></a> `map_rename`





## <a name="map_set_default"></a> `map_set_default`





## <a name="map_to_keyvaluelist"></a> `map_to_keyvaluelist`

 converts a map to a key value list 




## <a name="map_to_valuelist"></a> `map_to_valuelist`





## <a name="map_unpack"></a> `map_unpack`





## <a name="map_values"></a> `map_values`

 returns all values of the map which are passed as ARNG




## <a name="mm"></a> `mm`





## <a name="map_iterator"></a> `map_iterator`





## <a name="map_iterator_break"></a> `map_iterator_break`

 use this macro inside of a while(true) loop it breaks when the iterator is over
 e.g. this prints all key values in the map
 while(true) 
   map_iterator_break(myiterator)
   message("${myiterator.key} = ${myiterator.value}")
 endwhile()




## <a name="map_iterator_next"></a> `map_iterator_next`





## <a name="map_import_properties"></a> `map_import_properties`





## <a name="map_match_obj"></a> `map_match_obj`





## <a name="map_clone"></a> `map_clone`





## <a name="map_clone_deep"></a> `map_clone_deep`





## <a name="map_clone_shallow"></a> `map_clone_shallow`





## <a name="map_equal"></a> `map_equal`

 compares two maps and returns true if they are equal
 order of list values is important
 order of map keys is not important
 cycles are respected.




## <a name="map_equal_obj"></a> `map_equal_obj`





## <a name="map_foreach"></a> `map_foreach`

 executes action (key, value)->void
 on every key value pair in map
 exmpl: map = {id:'1',val:'3'}
 map_foreach("${map}" "(k,v)-> message($k $v)")
 prints 
  id;1
  val;3




## <a name="map_issubsetof"></a> `map_issubsetof`





## <a name="map_merge"></a> `map_merge`

 creates a union from all all maps passed as ARGN and combines them in result
 you can merge two maps by typing map_union(${map1} ${map1} ${map2})
 maps are merged in order ( the last one takes precedence)




## <a name="map_union"></a> `map_union`

 creates a union from all all maps passed as ARGN and combines them in the first
 you can merge two maps by typing map_union(${map1} ${map1} ${map2})
 maps are merged in order ( the last one takes precedence)







