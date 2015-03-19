function(test)
  project_open(".")
  ans(project)


  events_track(project_on_closing project_on_close project_on_closed)
  ans(tracker)

  timer_start(project_close)
  project_close("${project}")
  ans(result)
  timer_print_elapsed(project_close)
  assert("${result}" STREQUAL "${test_dir}/.cps/project.scmake")

  project_state_assert("${project}" closed) 
  assertf({tracker.project_on_closing[0].args[0]} STREQUAL "${project}")
  assertf({tracker.project_on_close[0].args[0]} STREQUAL "${project}")
  assertf({tracker.project_on_closed[0].args[0]} STREQUAL "${project}")

  assertf("{project.content_dir}" ISNULL)

endfunction()