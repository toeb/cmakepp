function(cmakepp_project_cli)
  commandline_args_get(--no-script)
  ans(args)

  message("opening project")
  project_open(".")
  ans(project)



 return()

endfunction()