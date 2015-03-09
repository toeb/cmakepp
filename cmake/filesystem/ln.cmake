## `(<target> <link>?)-><bool>` 
##
## creates a link from link to target on windows and linux
## if link is omitted then the link will be created in the local directory 
## with the same name as the target
function(ln)
  wrap_platform_specific_function(ln)
  ln(${ARGN})
  return_ans()
endfunction()

function(ln_Linux link target)
   set(args ${ARGN})
  list_extract_flag(args -s)
  ans(symbolic)

  path_qualify(link)

  list_pop_front(args)
  ans(link)

  if("${link}_" STREQUAL "_")
    get_filename_component(link "${target}" NAME )
  endif()
  return(false)
endfunction()


function(ln_Windows target)
  set(args ${ARGN})
  list_extract_flag(args -s)
  ans(symbolic)

  path_qualify(link)

  list_pop_front(args)
  ans(link)

  if("${link}_" STREQUAL "_")
    get_filename_component(link "${target}" NAME )
  endif()

  path_qualify(target)


  if(EXISTS "${target}" AND NOT IS_DIRECTORY "${target}")
    set(flags "/H")
  else()
    set(flags "/D" "/J")
  endif()
  string(REPLACE "/" "\\" link "${link}")
  string(REPLACE "/" "\\" target "${target}")

 # print_vars(link target flags)
  win32_cmd_lean("/C" "mklink" ${flags} "${link}" "${target}")
  ans_extract(error)
  if(error)
    return(false)
  endif()
  return(true)
endfunction()


