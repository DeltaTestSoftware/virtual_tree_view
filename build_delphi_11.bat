@echo off
setlocal

pushd "%~dp0Packages\RAD Studio 11"

echo Building Project 1 of 2...
call :build_all VirtualTreesR.dproj
if %errorlevel% neq 0 exit /b %errorlevel%

echo Building Project 2 of 2...
call :build_target VirtualTreesD.dproj Win32 Release
if %errorlevel% neq 0 exit /b %errorlevel%

exit /b 0


REM example usage
REM   call :build_all project_file.dproj
:build_all

echo   Building target 1 of 4...
call :build_target %~1 Win32 Debug
if %errorlevel% neq 0 exit /b %errorlevel%

echo   Building target 2 of 4...
call :build_target %~1 Win32 Release
if %errorlevel% neq 0 exit /b %errorlevel%

echo   Building target 3 of 4...
call :build_target %~1 Win64 Debug
if %errorlevel% neq 0 exit /b %errorlevel%

echo   Building target 4 of 4...
call :build_target %~1 Win64 Release
if %errorlevel% neq 0 exit /b %errorlevel%

exit /b 0


REM example usage
REM   call :build_target project_file.dproj Win64 Debug
:build_target

call :set_build_target %~1 %~2 %~3
if %errorlevel% neq 0 exit /b %errorlevel%

bds /b %~1
if %errorlevel% neq 0 exit /b %errorlevel%

exit /b 0


REM example usage
REM   call :set_build_target project_file.dproj Win64 Debug
:set_build_target

REM Replace the config.
powershell -Command get-content %~1 ^| %%{ $_ -replace \"<Config Condition.*\", \"<Config Condition=\"\"'`$(Config)'==''\"\">%~3</Config>\" } ^| Set-Content -Encoding UTF8 -Path %~1_temp
if %errorlevel% neq 0 exit /b %errorlevel%

REM Replace the platform.
powershell -Command get-content %~1_temp ^| %%{ $_ -replace \"<Platform Condition.*\", \"<Platform Condition=\"\"'`$(Platform)'==''\"\">%~2</Platform>\" } ^| Set-Content -Encoding UTF8 -Path %~1
if %errorlevel% neq 0 exit /b %errorlevel%

del %~1_temp
if %errorlevel% neq 0 exit /b %errorlevel%

exit /b 0


popd
