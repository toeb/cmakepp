## sets up the cmakepp environment 
## creates aliases
##    icmake - interactive cmakepp
##    cmakepp - commandline interface to cmakepp 
##    pkg - package manager command line interface
function(cmakepp_setup_environment)


  alias_create("icmake" "cmake -P ${installation_dir}/cmakepp.cmake -icmake")
  alias_create("cmakepp" "cmake -P ${installation_dir}/cmakepp.cmake")
  alias_create("cmakepp" "cmake -P ${installation_dir}/cmakepp.cmake cmakepp_project_cli")

  shell_env_set(CMAKEPP_PATH "${installation_dir}")


endfunction()