cmake_minimum_required(VERSION 2.8.12)

include("$ENV{CMAKEPP_PATH}")


project(MyProject)
project_open(. --force)


add_executable(myexe main.cpp)
