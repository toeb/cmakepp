function(package_handle_filter __handles uri)
      uri_coerce(uri)
  
      map_tryget(${uri} uri)
      ans(uri_string)

      ## return all handles if query uri is ?*
      if("${uri_string}" STREQUAL "?*")
        return_ref(${__handles})
      endif()

      foreach(package_handle ${${__handles}})
        map_tryget(${package_handle} uri)
        ans(package_uri)
        if("${package_uri}" STREQUAL "${uri_string}")
          return(${package_handle})
        endif()
      endforeach()

      assign(id_query = uri.params.id)
      if(id_query)
        set(result)
        foreach(package_handle ${${__handles}})
          assign(pid = package_handle.package_descriptor.id)
          if("${pid}_" STREQUAL "${id_query}_")
            list(APPEND result ${package_handle})
          endif() 
        endforeach()
        return_ref(result)
      endif()

      ## todo...

      return()


    endfunction()