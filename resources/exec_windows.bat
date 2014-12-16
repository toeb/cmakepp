@echo off
rem http://ss64.org/viewtopic.php?id=1495
setlocal enabledelayedexpansion

if "%~1" NEQ "" (
	if "%~1" NEQ "-help" (
		call :proc %*
		exit /b %ERRORLEVEL%
	)
)

call :echoHelp
exit /b

:proc
	call :argParser %*

	if "%exec%" EQU "" (
		call :err 1000
		exit /b %ERRORLEVEL%
	)

	if "%host%" NEQ "" (
		set host=/NODE:%host%
		if "%user%" NEQ "" (
			set user=/USER:%user%
			if "%pass%" NEQ "" (
				set pass=/PASSWORD:%pass%
			)
		)
	)

	if "%record%" NEQ "" (
		set record=/RECORD:%record%
	)

	set global_params=%record% %host% %user% %pass%

	for /f "usebackq tokens=*" %%G IN (`wmic  %global_params%  process call create "%exec% %commandline%"^,"%workdir%"`) do ( 
		rem echo %%G
		set _tmp=%%G
		set _tmp=!_tmp:^>=^^^>!
		echo !_tmp! | find "ProcessId" > nul && (
			for /f  "tokens=2 delims=;= " %%H in ('echo !_tmp!') do (
				call set /A PID=%%H
			)
		)
		echo !_tmp! | find "ReturnValue" > nul && (
			for /f  "tokens=2 delims=;= " %%I in ('echo !_tmp!') do (
				call set /A RETCOD=%%I
			)
		)
		call :concat
	)
	set _tmp=
	
	rem successful execution
	if "%PID%" NEQ "" (
		echo %PID%
		exit /b
		rem exit /B %PID%
	) else (
		call :err %RETCOD%
	)
exit /b %ERRORLEVEL%


:concat

	call set output=%output% ^& echo !_tmp:^>=^^^>!
exit /b

:argParser

	set comstr=-exec-commandline-workdir-host-user-pass-record
	:nextShift
	set /A shifter=shifter+1
	echo %comstr% | find "%~1" > nul && (
		set _tmp=%~1
		set !_tmp:-=!=%~2
	)
	shift &	shift
	if %shifter% LSS 7 goto :nextShift
	set _tmp=
	set shifter=
exit /b

:echoHelp

	echo %~n0 -exec executubale {-commandline command_line} { -workdir working_directory} 
	echo  {-host  remote_host {-user user {-pass password}}} {-record path_to_xml_output}
	echo\
	echo localhost cant' be used as in -host variable
	echo Examples:
	echo %~n0  -exec "notepad" -workdir "c:/"  -record "test.xml" -commandline "/A startpid.txt"
	echo %~n0  -exec "cmd" -workdir "c:/"  -record "test.xml" -host remoteHost -user User
exit /b

:err
	if %1 EQU 2          (set errmsg=Access Denied)
	if %1 EQU 3          (set errmsg=Insufficient Privilege)
	if %1 EQU 8          (set errmsg=Unknown failure ^& echo Hint: Check if the executable and workdit exists or if command line parameters are correct.)
	if %1 EQU 9          (set errmsg=Path Not Found ^& echo Hint: check if the workdir exists on the remote machine.)
	if %1 EQU 21         (set errmsg=Invalid Parameter ^& echo Hint: Check executable path. Check if host and user are corect.)
	if %1 EQU 1000       (set errmsg=Executable not defined.)
	if "%errmsg:~0,1%" EQU "" (set errmsg=%output% ^& echo Hint: brackets, quotes or commas in the password may could breack the script.)

	echo %errmsg%
exit /b %1