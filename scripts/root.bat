call:%*
goto:eof

REM #####################
REM ## ROOT CHECK
REM #####################
:check
set /p "=Checking for SU binary..." < nul
tools\adb shell %BB% ls /system/bin/su>tmpbak\su
set /p su=<tmpbak\su
if NOT "!su!" == "[1;32m/system/bin/su[0m" (
	tools\adb shell %BB% ls /system/xbin/su>tmpbak\su
	set /p su=<tmpbak\su
	if NOT "!su!" == "[1;32m/system/xbin/su[0m" (
	   echo FAILD
	) else (
	    set su=su -c
		echo OK
	)
)
set /p "=Requesting root permissions..." < nul
tools\adb shell su -c "%BB% echo true">tmpbak\rootPermission
set /p rootPermission=<tmpbak\rootPermission
if NOT "!rootPermission!" == "true" ( 
	 set su="/data/local/tmp/iovyroot"
	    echo FAILD
		cls
		%CHOICE% /c:10 %CHOICE_TEXT_PARAM% "can't detect root, want to try temp root[iovyroot] 1 = OK, 0 = Quit "
		set root_decision=!errorlevel!
		if "!root_decision!" == "1" (
		    echo ============================================================
		    echo                         IOVYROOT            
		    echo ======================Read Carefully========================
		    echo due to some newer devices prevent to write on system partition
		    echo resides at kernel as dm-verity ,so any modification on system partition  
		    echo will set device at bootloop, till now we can't totally disable it 
		    echo but we can disable it temporarly and get root shell to backup TA
		    echo thanks to [zxz0o0] to give us this chance        [STILL IN BETA]
			echo =============================================================
			echo  1. Backup                             2.Restore
			echo                      3.Quit
		    echo =============================================================
		    tools\adb.exe push tools\iovyroot /data/local/tmp/iovyroot> nul 2>&1
		    tools\adb.exe shell chmod 777 /data/local/tmp/iovyroot
			%CHOICE% /c:123 %CHOICE_TEXT_PARAM% "Please make your decision:"
			set iovy_Backup_Select=!errorlevel!
			if "!iovy_Backup_Select!" == "1" (
			    call scripts\backup.bat backupTA
			)
			if "!iovy_Backup_Select!" == "2" (
			    call scripts\restore.bat restoreTA
			)
			if "!iovy_Backup_Select!" == "3" (
			    goto:eof
			)
			set root_decision=
			set iovy_Backup_Select=
	        goto:eof
		) else (
		    goto:eof
		)
)
echo OK
set %~1=1
del /q /s tmpbak\su > nul 2>&1
del /q /s tmpbak\rootPermission > nul 2>&1
goto:eof