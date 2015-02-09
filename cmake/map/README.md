## Maps - Structured Data in CMake



Maps are very versatile and are missing dearly from CMake in my opinion. Maps are references as is standard in many languages. They are signified by having properties which are adressed by keys and can take any value.

Due to the "variable variable" system (ie names of variables are string which can be generated from other variables) it is very easy to implement the map system. Under the hood a value is mapped by calling `ref_set(${map}.${key})`.  



### Function List


* [bfs](#bfs)
* [cmake_string_to_json](#cmake_string_to_json)
* [dfs](#dfs)
* [dfs_callback](#dfs_callback)
* [dfs_recurse](#dfs_recurse)
* [map_check](#map_check)
* [map_exists](#map_exists)
* [map_format](#map_format)
* [map_graphsearch](#map_graphsearch)
* [map_import_properties](#map_import_properties)
* [map_match_obj](#map_match_obj)
* [map_order](#map_order)
* [map_print](#map_print)
* [map_print_format](#map_print_format)
* [map_query](#map_query)
* [map_select](#map_select)
* [map_transform](#map_transform)
* [map_where](#map_where)

### Function Descriptions

## <a name="bfs"></a> `bfs`





## <a name="cmake_string_to_json"></a> `cmake_string_to_json`





## <a name="dfs"></a> `dfs`





## <a name="dfs_callback"></a> `dfs_callback`





## <a name="dfs_recurse"></a> `dfs_recurse`





## <a name="map_check"></a> `map_check`





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





## <a name="map_select"></a> `map_select`





## <a name="map_transform"></a> `map_transform`





## <a name="map_where"></a> `map_where`








