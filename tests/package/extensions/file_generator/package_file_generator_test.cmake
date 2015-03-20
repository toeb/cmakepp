function(test)




  function(muuuu)
    json_indented(${ARGN})
    return_ans()
  endfunction()


  mock_package_source("mock" A B "A=>B")
  ans(package_source)

  project_open("")
  ans(project)

 assign(project.project_descriptor.package_source = package_source)
  assign(!project.package_descriptor.id = 'mypackage')
  assign(!project.package_descriptor.generate = "{
    'dir1/hello-{package_descriptor.id}.txt':'hello from @package.uri <% foreach(i RANGE 1 3) %>yup<% endforeach()%>',
    'asd.json':'muuuu  ({asd:1}) '
    }")


  timer_start(t1)
  project_install(${project})
  timer_print_elapsed(t1)

  assert(EXISTS "${test_dir}/dir1/hello-mypackage.txt")
  assert(EXISTS "${test_dir}/asd.json")
  json_read(asd.json)
  ans(res)
  assertf({res.asd} EQUAL 1)
  fread("dir1/hello-mypackage.txt")
  ans(res)
  assert("${res}" STREQUAL "hello from project:root yupyupyup")


endfunction()