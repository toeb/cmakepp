function(test)

    timer_start(timer1)
    git_cached_clone("https://github.com/toeb/cmakepp" "dir1")
    rethrow(true)
    timer_print_elapsed(timer1)

    timer_start(timer2)
    git_cached_clone("https://github.com/toeb/cmakepp" "dir2")
    rethrow(true)
    timer_print_elapsed(timer2)

    ## reclone
    timer_start(timer22)
    git_cached_clone("https://github.com/toeb/cmakepp" "dir2")
    ans(res)
    timer_print_elapsed(timer22)
    assert(NOT res)

    timer_start(timer3)
    git_cached_clone("https://github.com/toeb/cmakepp" "dir2" --read package.cmake)
    rethrow(true)
    ans(res)
    assert(res)
    timer_print_elapsed(timer3)

    message("res ${res}")





endfunction()