@if "%SCM_TRACE_LEVEL%" NEQ "4" @echo off

SET GRADLE_HOME=%~dp0%\gradle
SET GRADLE_HOME_CMD=%GRADLE_HOME%\bin\gradle.bat

:: Setup
:: -----

setlocal enabledelayedexpansion

IF NOT DEFINED DEPLOYMENT_SOURCE (
  SET DEPLOYMENT_SOURCE=%~dp0%.
)

IF NOT DEFINED DEPLOYMENT_TARGET (
  SET DEPLOYMENT_TARGET=%~dp0%\..\wwwroot
)

IF EXIST "%GRADLE_HOME_CMD%" (
  call :ExecuteCmd "%GRADLE_HOME_CMD%" clean war
  IF !ERRORLEVEL! NEQ 0 goto error
)


:: copy war file to wwwroot

IF NOT EXIST "%DEPLOYMENT_TARGET%"\webapps (
   mkdir "%DEPLOYMENT_TARGET%"\webapps > NUL 2>&1
)

COPY /Y "%DEPLOYMENT_SOURCE%"\build\libs\kinmugi.war "%DEPLOYMENT_TARGET%"\webapps\ROOT.war
IF !ERRORLEVEL! NEQ 0 goto error

goto end

:: Execute command routine that will echo out when error
:ExecuteCmd
setlocal
set _CMD_=%*
call %_CMD_%
if "%ERRORLEVEL%" NEQ "0" echo Failed exitCode=%ERRORLEVEL%, command=%_CMD_%
exit /b %ERRORLEVEL%

:error
endlocal
echo An error has occurred during web site deployment.
call :exitSetErrorLevel
call :exitFromFunction 2>nul

:exitSetErrorLevel
exit /b 1

:exitFromFunction
()

:end
endlocal
echo Finished successfully.