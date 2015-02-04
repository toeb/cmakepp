   
      function(list_remove_duplicates __lst)
        list(LENGTH ${__lst} len)
        if(len EQUAL 0)
          return()
        endif()
        list(REMOVE_DUPLICATES repos)
        return()
      endfunction()