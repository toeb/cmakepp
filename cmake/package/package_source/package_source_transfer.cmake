function(package_source_transfer)
      
      set(args ${ARGN})
      string_semicolon_encode("${args}")
      ans(args)
      string(REPLACE "=>" ";" args "${args}")
      list_extract(args soure_args sink_args)
      string_semicolon_decode("${soure_args}")
      ans(source_args)
      list_pop_back(source_args)
      list_pop_front(source_args)
      ans(source)
      string_semicolon_decode("${sink_args}")
      ans(sink_args)
      list_pop_front(sink_args)
      list_pop_front(sink_args)
      ans(sink)

      path_temp()
      ans(temp_dir)
      
      assign(package_handle = source.pull(${source_args} ${temp_dir}))

      ## 
      if(NOT package_handle)
        rm(-r "${temp_dir}")
        return()
      endif()


      ## 
      assign(return_uri = sink.push("${package_handle}" ${sink_args}))


      ## delete tempdir
      if(EXISTS "${temp_dir}")
        rm(-r "${temp_dir}")
      endif()


        
      return_ref(return_uri)
      
    endfunction()
