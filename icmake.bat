@echo off
set scriptPath= %~dp0%\icmake.cmake
if  [%1]==[] goto Continue
set allArgs=%*
set allArgs=%allArgs:"=\"%
set allArgs=%allArgs:;=\;%
:Continue
cmake -P %scriptPath%
