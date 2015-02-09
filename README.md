![cmakepp logo](https://raw.githubusercontent.com/toeb/cmakepp/master/logo.png "cmakepp logo")

## A CMake Enhancement Suite
[![Travis branch](https://img.shields.io/travis/toeb/cmakepp/master.svg)](https://travis-ci.org/toeb/cmakepp)
[![GitHub stars](https://img.shields.io/github/stars/toeb/cmakepp.svg?)](https://github.com/toeb/cmakepp/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/toeb/cmakepp.svg)](https://github.com/toeb/cmakepp/network)
[![GitHub issues](https://img.shields.io/github/issues/toeb/cmakepp.svg)](https://github.com/toeb/cmakepp/issues)
[![biicode block](https://img.shields.io/badge/toeb%2Fcmakepp-DEV%3A0-yellow.svg)](https://www.biicode.com/toeb/cmakepp)  
[![Project Stats](https://www.ohloh.net/p/cmakepp/widgets/project_thin_badge.gif)](https://www.ohloh.net/p/cmakepp)


# Installing

You have multiple options for install `cmakepp` the only prerequisite for all options is that cmake is installed with version `>=2.8.7`. 


* [Install by Console](#install_console) - Recommended
* Use the [Biicode Block](https://www.biicode.com/toeb/cmakepp)
* [Download a release](https://github.com/toeb/cmakepp/releases) and include it in your cmake script file - If you do not want to run the tests or have access to the single function files this option is for you
  - [Manually setup aliases](#install_aliases)
* Clone the repository and include `cmakepp.cmake` in your `CMakeLists.txt` (or other cmake script)

# Usage
Look through the files in the package.  Most functions will be commented and the other's usage can be inferred.  All functions are avaiable as soon as you include the cmakepp.cmake file.

# Testing
To test the code (alot is tested but not all) run the following in the root dir of cmakepp *this takes long :)*

``` 
cmake -P build/script.cmake 
```

# Feature Overview

`cmakepp` has a lot of different functions. I tried to subdivide them into some meaningful sections.

* [Collections](cmake/collections)
* [Date and Time functions](cmake/datetime)
* [Events](cmake/events)
* [Filesystem](cmake/filesystem)
* [Functions](cmake/function)
* [Logging Functions](cmake/log)
* [Maps - Structured Data in CMake](cmake/map)
* [Objects ](cmake/object)
* [Package Management](cmake/package)
* [User Data](cmake/persistence)
* [Process Management](cmake/process)
* [Reference Values](cmake/ref)
* [Windows Registry](cmake/reg)
* [Parsing and handling semantic versions](cmake/semver)
* [String Functions](cmake/string)
* [Targets](cmake/targets)
* [Uniform Resource Identifiers (URIs)](cmake/uri)
* [HTTP Client](cmake/web)

