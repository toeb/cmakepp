## Maps - Structured Data in CMake



Maps are very versatile and are missing dearly from CMake in my opinion. Maps are references as is standard in many languages. They are signified by having properties which are adressed by keys and can take any value.

Due to the "variable variable" system (ie names of variables are string which can be generated from other variables) it is very easy to implement the map system. Under the hood a value is mapped by calling `ref_set(${map}.${key})`.  



### Function List


* [bfs](#bfs)
* [cmake_string_to_json](#cmake_string_to_json)
* [map_append](#map_append)
* [map_append_string](#map_append_string)
* [map_append_unique](#map_append_unique)
* [map_delete](#map_delete)
* [map_get](#map_get)
* [map_get_special](#map_get_special)
* [map_has](#map_has)
* [map_isvalid](#map_isvalid)
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
* [map_defaults](#map_defaults)
* [map_edit](#map_edit)
* [map_ensure](#map_ensure)
* [map_extract](#map_extract)
* [map_fill](#map_fill)
* [map_from_keyvaluelist](#map_from_keyvaluelist)
* [map_has_all](#map_has_all)
* [map_has_any](#map_has_any)
* [map_invert](#map_invert)
* [map_isempty](#map_isempty)
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
* [map_set_if_missing](#map_set_if_missing)
* [map_to_keyvaluelist](#map_to_keyvaluelist)
* [map_to_valuelist](#map_to_valuelist)
* [map_unpack](#map_unpack)
* [map_values](#map_values)
* [mm](#mm)
* [map_iterator](#map_iterator)
* [map_iterator_break](#map_iterator_break)
* [map_iterator_next](#map_iterator_next)
* [map_check](#map_check)
* [map_decycle](#map_decycle)
* [map_exists](#map_exists)
* [map_format](#map_format)
* [map_graphsearch](#map_graphsearch)
* [map_import_properties](#map_import_properties)
* [map_match_obj](#map_match_obj)
* [map_order](#map_order)
* [map_print](#map_print)
* [map_print_format](#map_print_format)
* [map_query](#map_query)
* [map_restore_refs](#map_restore_refs)
* [map_select](#map_select)
* [map_transform](#map_transform)
* [map_where](#map_where)
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

## <a name="bfs"></a> `bfs`





## <a name="cmake_string_to_json"></a> `cmake_string_to_json`





## <a name="map_append"></a> `map_append`





## <a name="map_append_string"></a> `map_append_string`





## <a name="map_append_unique"></a> `map_append_unique`

 map_append_unique 
 
 appends values to the <map>.<prop> and ensures 
 that <map>.<prop> stays unique 




## <a name="map_delete"></a> `map_delete`





## <a name="map_get"></a> `map_get`





## <a name="map_get_special"></a> `map_get_special`





## <a name="map_has"></a> `map_has`





## <a name="map_isvalid"></a> `map_isvalid`





## <a name="map_keys"></a> `map_keys`





## <a name="map_new"></a> `map_new`





## <a name="map_remove"></a> `map_remove`





## <a name="map_remove_item"></a> `map_remove_item`

 map_remove_item

 removes the specified items from <map>.<prop>
 returns the number of items removed




## <a name="map_set"></a> `map_set`





## <a name="map_set_hidden"></a> `map_set_hidden`





## <a name="map_set_special"></a> `map_set_special`





## <a name="map_tryget"></a> `map_tryget`





## <a name="dfs"></a> `dfs`





## <a name="dfs_callback"></a> `dfs_callback`





## <a name="list_match"></a> `list_match`





## <a name="map_all_paths"></a> `map_all_paths`





## <a name="map_at"></a> `map_at`

 returns the value at idx




## <a name="map_capture"></a> `map_capture`

 captures the listed variables in the map




## <a name="map_capture_new"></a> `map_capture_new`

 captures a new map from the given variables
 example
 set(a 1)
 set(b 2)
 set(c 3)
 map_capture_new(a b c)
 ans(res)
 json_print(${res})
 --> 
 {
   "a":1,
   "b":2,
   "c":3 
 }




## <a name="map_clear"></a> `map_clear`





## <a name="map_copy_shallow"></a> `map_copy_shallow`





## <a name="map_defaults"></a> `map_defaults`





## <a name="map_edit"></a> `map_edit`





## <a name="map_ensure"></a> `map_ensure`





## <a name="map_extract"></a> `map_extract`





## <a name="map_fill"></a> `map_fill`

 files non existing or null values of lhs with values of rhs




## <a name="map_from_keyvaluelist"></a> `map_from_keyvaluelist`





## <a name="map_has_all"></a> `map_has_all`





## <a name="map_has_any"></a> `map_has_any`





## <a name="map_invert"></a> `map_invert`





## <a name="map_isempty"></a> `map_isempty`





## <a name="map_key_at"></a> `map_key_at`

 returns the key at the specified position




## <a name="map_match"></a> `map_match`

 checks if all fields specified in actual rhs are equal to the values in expected lhs
 recursively checks submaps




## <a name="map_matches"></a> `map_matches`





## <a name="map_match_properties"></a> `map_match_properties`





## <a name="map_omit"></a> `map_omit`





## <a name="map_omit_regex"></a> `map_omit_regex`





## <a name="map_overwrite"></a> `map_overwrite`

 overwrites all values of lhs with rhs




## <a name="map_pairs"></a> `map_pairs`





## <a name="test"></a> `test`





## <a name="map_path_get"></a> `map_path_get`





## <a name="map_path_set"></a> `map_path_set`





## <a name="map_peek_back"></a> `map_peek_back`





## <a name="map_peek_front"></a> `map_peek_front`





## <a name="map_pick"></a> `map_pick`





## <a name="map_pick_regex"></a> `map_pick_regex`





## <a name="map_pop_back"></a> `map_pop_back`





## <a name="map_pop_front"></a> `map_pop_front`





## <a name="map_promote"></a> `map_promote`





## <a name="map_property_length"></a> `map_property_length`

 returns the length of the specified property




## <a name="map_push_back"></a> `map_push_back`





## <a name="map_push_front"></a> `map_push_front`





## <a name="map_rename"></a> `map_rename`

 renames a key in the specified map




## <a name="map_set_if_missing"></a> `map_set_if_missing`





## <a name="map_to_keyvaluelist"></a> `map_to_keyvaluelist`





## <a name="map_to_valuelist"></a> `map_to_valuelist`





## <a name="map_unpack"></a> `map_unpack`

 unpacks the specified reference to a map
 let a map be stored in the var 'themap'
 let it have the key/values a/1 b/2 c/3
 map_unpack(themap) will create the variables
 ${themap.a} contains 1
 ${themap.b} contains 2
 ${themap.c} contains 3




## <a name="map_values"></a> `map_values`





## <a name="mm"></a> `mm`

 function which generates a map 
 out of the passed args 
 or just returns the arg if it is already valid




## <a name="map_iterator"></a> `map_iterator`

 initializes a new mapiterator




## <a name="map_iterator_break"></a> `map_iterator_break`





## <a name="map_iterator_next"></a> `map_iterator_next`

 this function moves the map iterator to the next position
 and returns true if it was possible
 e.g.
 map_iterator_next(myiterator) 
 ans(ok) ## is true if iterator had a next element
 variables ${myiterator.key} and ${myiterator.value} are available




## <a name="map_check"></a> `map_check`





## <a name="map_decycle"></a> `map_decycle`





## <a name="map_exists"></a> `map_exists`





## <a name="map_format"></a> `map_format`





## <a name="map_graphsearch"></a> `map_graphsearch`





## <a name="map_import_properties"></a> `map_import_properties`

 imports the specified properties into the current scope
 e.g map = {a:1,b:2,c:3}
 map_import_properties(${map} a c)
 -> ${a} == 1 ${b} == 2




## <a name="map_match_obj"></a> `map_match_obj`

 returns true if actual has all properties (and recursive properties)
 that expected has




## <a name="map_order"></a> `map_order`





## <a name="map_print"></a> `map_print`





## <a name="map_print_format"></a> `map_print_format`





## <a name="map_query"></a> `map_query`





## <a name="map_restore_refs"></a> `map_restore_refs`





## <a name="map_select"></a> `map_select`





## <a name="map_transform"></a> `map_transform`





## <a name="map_where"></a> `map_where`





## <a name="map_clone"></a> `map_clone`





## <a name="map_clone_deep"></a> `map_clone_deep`





## <a name="map_clone_shallow"></a> `map_clone_shallow`





## <a name="map_equal"></a> `map_equal`





## <a name="map_equal_obj"></a> `map_equal_obj`

 compares two maps for value equality
 lhs and rhs may be objectish 




## <a name="map_foreach"></a> `map_foreach`





## <a name="map_issubsetof"></a> `map_issubsetof`





## <a name="map_merge"></a> `map_merge`





## <a name="map_union"></a> `map_union`








