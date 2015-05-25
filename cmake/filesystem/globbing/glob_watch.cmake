function(test)

  function(watch_glob)

    promise_from_anonymous(()
        
        message("promise: \${promise}")
        map_tryget(\${promise} continue)
        ans(continue)
        if(NOT continue)
          _message("stopping")
          return()
        endif()

        map_tryget(\${promise} files)
        ans(files)


        glob(${ARGN})
        ans(new_files)

        set_difference(files new_files)
        ans(removed_files)

        set_difference(new_files files)
        ans(added_files)


        _message(files added \${added_files})
        _message(files removed  \${removed_files})

        promise_from_task(\${task})
        ans(next)
        return(${next})
      )
    ans(watcher)
    map_set(${watcher} continue true)
    json_print(${watcher})
    _message("lol ${watcher}")

    return(${watcher})
  endfunction()





  watch_glob(*.txt)
  ans(task)

  promise_wait(${task} --ticks 100)


endfunction()