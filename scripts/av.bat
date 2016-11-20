call:%*
goto:eof


REM ########################
REM ## Android Version Check
REM ########################
:androidVersion
set /p "=Checking for Android Version..." < nul
tools\adb.exe shell getprop ro.build.version.release>tmpbak\androidVersion
set /p androidVersion=<tmpbak\androidVersion
if "%androidVersion%" == "4.4.4" (
    set PARTITION_BY_NAME=/dev/block/platform/msm_sdcc.1/by-name/TA
)
if "%androidVersion%" == "4.4.2" (
    set PARTITION_BY_NAME=/dev/block/platform/msm_sdcc.1/by-name/TA
) 
if "%androidVersion%" == "4.1.2" (
    set PARTITION_BY_NAME=/dev/block/platform/msm_sdcc.1/by-name/TA
) 
if "%androidVersion%" == "4.2.2" (
    set PARTITION_BY_NAME=/dev/block/platform/msm_sdcc.1/by-name/TA
) else (
    set PARTITION_BY_NAME=/dev/block/bootdevice/by-name/TA
)
echo %androidVersion%
del /q /s tmpbak\androidVersion > nul 2>&1
goto:eof