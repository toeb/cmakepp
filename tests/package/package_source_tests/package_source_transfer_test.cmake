function(test)

    

    path_package_source()
    ans(path_source)

    fwrite_data(pkg1/package.cmake "{id:'mypkg'}" --json)


    package_source_transfer(${path_source} pkg1 => ${path_source} pkg2)

    ans(res)
    assert(res)
    assert(EXISTS "${test_dir}/pkg2/package.cmake")    



    package_source_transfer(${path_source} pkg1 --reference => ${path_source} pkg2)

    ans(res)
    assert(res)
    assert(EXISTS "${test_dir}/pkg2/package.cmake")    



endfunction()