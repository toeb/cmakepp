    cmake_minimum_required(VERSION 2.8.12)
    ## CMakeLists.txt for a simple project 
    set(current_dir "${CMAKE_CURRENT_SOURCE_DIR}")
    ## get cmakepp
    if(NOT EXISTS "${current_dir}/cmakepp.cmake")
      file(DOWNLOAD "https://github.com/toeb/cmakepp/releases/download/v0.0.3/cmakepp.cmake" "${current_dir}/cmakepp.cmake")
    endif()

    include("${current_dir}/cmakepp.cmake")
        
    if(NOT EXISTS ${current_dir}/dependencies/eigen3)
     message("installing Eigen3 from bitbucket")
     pull_package(eigen/eigen?tag=3.1.0 dependencies/eigen3)
     ans(package_handle)
     if(NOT package_handle)
      message(FATAL_ERROR "could not pull Eigen3")
     endif()
     ## print the package information returned
     json_print(${package_handle})
    endif()
    
    ## from here on everything can be a normal cmakelists file
    project(myproject)
    
    include_directories("dependencies/eigen3")
    
    fwrite("main.cpp" "
    #include <iostream>
    #include <Eigen/Dense>
    using Eigen::MatrixXd;
    int main()
    {
      MatrixXd m(2,2);
      m(0,0) = 3;
      m(1,0) = 2.5;
      m(0,1) = -1;
      m(1,1) = m(1,0) + m(0,1);
      std::cout << m << std::endl;
    }
    ")
    add_executable(myexe "main.cpp")

