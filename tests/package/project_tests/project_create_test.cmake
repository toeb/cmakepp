function(test)

    fwrite(pr0 "hello")
    ## pr1
    mkdir(pr2)
    fwrite(pr3/hello.txt "hello")




    ## new project in a existing file
    project_create(pr0)
    ans(res)

    assert(NOT res)


    ## new project overwriting existing file
    project_create(pr0 --force)
    ans(res)

    assert(res)
    assert(IS_DIRECTORY "${test_dir}/pr0")
    assert(EXISTS "${test_dir}/pr0/.cps/config.qm")
    assert(EXISTS "${test_dir}/pr0/.cps/package_descriptor.qm")

    ## new project in a non existing dir
    project_create(pr1)
    ans(res)

    assert(res)
    assert(IS_DIRECTORY "${test_dir}/pr1")
    assert(EXISTS "${test_dir}/pr1/.cps/config.qm")
    assert(EXISTS "${test_dir}/pr1/.cps/package_descriptor.qm")

    ## new project in empty existing dir
    project_create(pr2)
    ans(res)

    assert(res)
    assert(IS_DIRECTORY "${test_dir}/pr2")
    assert(EXISTS "${test_dir}/pr2/.cps/config.qm")
    assert(EXISTS "${test_dir}/pr2/.cps/package_descriptor.qm")

    ## new project in non empty existing dir
    project_create(pr3)
    ans(res)

    assert(NOT res)


    ## new project in non empty existing dir forced
    project_create(pr3 --force)
    ans(res)

    assert(res)
    assert(IS_DIRECTORY "${test_dir}/pr3")
    assert(EXISTS "${test_dir}/pr3/.cps/config.qm")
    assert(EXISTS "${test_dir}/pr3/.cps/package_descriptor.qm")







endfunction()