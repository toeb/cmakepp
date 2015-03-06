## <a name="package_handle_update_dependencies"></a> `package_handle_update_dependencies`

 `(<package handle> <~package changeset>)-> <old changes>`
 
 modified the dependencies of a package handle
 ```
  package_handle_update_dependencies(${package_handle} "A" "B conflict") 
  package handle: {
 "package_descriptor":{
  "dependencies":{
   "A":true,
   "B":false
  }
 }
}
 ```




