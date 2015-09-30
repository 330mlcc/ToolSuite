@ECHO OFF

REM * Setup - Move to MZK Path
PUSHD "%~dp0"

CLS

REM * Check - Compression
IF NOT EXIST "DB\CHECK\MZK" (
	ECHO ���� ������ �ùٸ��� ���� �� �������ֽñ� �ٶ��ϴ�.
	ECHO.
	PAUSE
	EXIT /B
)

REM * Setup - Variable Initialization
SET ACTIVESCAN=0
SET AUTOMODE=0
SET CHKEXPLORER=0
SET CURRENTDATE=NULL
SET DATECHK=0
SET DDRV=NULL
SET ERRCODE=0
SET NUMTMP=0
SET OSVER=NULL
SET PATHDUMP=NULL
SET REGTMP=NULL
SET RPTDATE=NULL
SET STRTMP=NULL
SET VK=0

SET MZKALLUSERSPROFILE=
SET MZKAPPDATA=
SET MZKCOMMONPROGRAMFILES=
SET MZKCOMMONPROGRAMFILESX86=
SET MZKLOCALAPPDATA=
SET MZKLOCALLOWAPPDATA=
SET MZKPROGRAMFILES=
SET MZKPROGRAMFILESX86=
SET MZKPUBLIC=
SET MZKSYSTEMROOT=
SET MZKUSERPROFILE=

SET YNAAA=
SET YNBBB=
SET YNCCC=

GOTO PASSED

:ERROR104
SET ERRCODE=104 & GOTO MZK

:PASSED
REM * Check - Required Variables
IF NOT DEFINED SYSTEMDRIVE (
	IF NOT DEFINED HOMEDRIVE (
		SET ERRCODE=104
	) ELSE (
		SET "SYSTEMDRIVE=%HOMEDRIVE%"
	)
)
IF NOT DEFINED SYSTEMROOT (
	IF NOT DEFINED WINDIR (
		SET ERRCODE=104
	) ELSE (
		SET "SYSTEMROOT=%WINDIR%"
	)
)

REM * Setup - Path
IF DEFINED PATH SET "PATHDUMP=%PATH%"
SET "PATH=%SYSTEMROOT%\System32;%SYSTEMROOT%\SysWOW64;%SYSTEMROOT%\System32\wbem;%SYSTEMROOT%\SysWOW64\wbem;%PATH%"

REM * Check - Random Variables
IF NOT DEFINED RANDOM (
	SET RANDOM=11111
)

REM * Setup - Random Variables
SET /A RAND=%RANDOM% * 99

DEL /F /Q /A DB_ACTIVE\*.DB >Nul 2>Nul & DEL /F /Q /S /A DB_EXEC\*.DB >Nul 2>Nul

REM * Check - Supported Language
SETLOCAL ENABLEDELAYEDEXPANSION
CHCP.COM 949 2>Nul|TOOLS\GREP\GREP.EXE -Fq "949" >Nul 2>Nul
IF !ERRORLEVEL! NEQ 0 (
	ENDLOCAL
	CLS
	ECHO Oops, Unsupported Korean Language ^!
	ECHO.
	PAUSE
	EXIT
) ELSE (
	ENDLOCAL
)

CLS

>VARIABLE\CHCK ECHO 0

REM * Reset - Malicious AppInit_DLLs Values (x64 or x86)
FOR /F "DELIMS=" %%Z IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Windows\AppInit_DLLs" 2^>Nul') DO (
	IF /I "%%Z" == "WS2HELP.DLL" (
		TOOLS\000.000 ADD "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Windows" /v AppInit_DLLs /d "" /f >Nul 2>Nul
		>VARIABLE\CHCK ECHO 1
	)
)
FOR /F "DELIMS=" %%Z IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows\AppInit_DLLs" 2^>Nul') DO (
	IF /I "%%Z" == "WS2HELP.DLL" (
		TOOLS\000.000 ADD "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows" /v AppInit_DLLs /d "" /f >Nul 2>Nul
		>VARIABLE\CHCK ECHO 1
	)
)
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\CHCK SET /P CHCK=
IF !CHCK! EQU 1 (
	ENDLOCAL
	ECHO �� �˸�
	ECHO.
	ECHO ��ũ��Ʈ ������ �����ϴ� �Ǽ� �ڵ� ���� ���̺귯�� ���� �߰ߵǾ� �����߽��ϴ�.
	ECHO.
	ECHO ����� �� �ٽ� �������ֽñ� �ٶ��ϴ�.
	ECHO.
	PAUSE
	EXIT /B
) ELSE (
	ENDLOCAL
)

REM * Setup - Window Size
MODE.COM CON COLS=98 LINES=30 >Nul 2>Nul

REM * Setup *****
<TOOLS\000.001 SET /P DBDATE=
<TOOLS\000.002 SET /P CKEY=
<TOOLS\000.003 SET /P COUNT=
<TOOLS\000.004 SET /P DBVER=
<TOOLS\000.006 SET /P CURRENTDATE=

REM * Setup - Title
SET "MZKTITLE=Malware Zero Kit / Virus Zero Season 2 / ViOLeT / DB: %DBDATE% V%DBVER%"

TITLE %MZKTITLE% 2>Nul

REM * Initialization
ECHO  ������������������������������������������������������������������������������������������������
ECHO.
ECHO.
ECHO         ��      ��    ����    ��          ��      ��    ����    �����    ������
ECHO         ���  ���  ��      ��  ��          ��  ��  ��  ��      ��  ��      ��  ��
ECHO         ��  ��  ��  ������  ��          ��  ��  ��  ������  �����    �����
ECHO         ��      ��  ��      ��  ��          ��  ��  ��  ��      ��  ��      ��  ��
ECHO         ��      ��  ��      ��  ������    ��  ��    ��      ��  ��      ��  ������
ECHO.
ECHO         ������  ������  �����      ����    ��      ��  ������  ������
ECHO               ��    ��          ��      ��  ��      ��  ��  ���        ��          ��
ECHO             ��      �����    �����    ��      ��  ���            ��          ��
ECHO           ��        ��          ��      ��  ��      ��  ��  ���        ��          ��
ECHO         ������  ������  ��      ��    ����    ��      ��  ������      ��
ECHO.
ECHO.
ECHO                                      ^[DB: %DBDATE% V%DBVER%^]
ECHO.
IF %RANDOM% EQU 7777 (
	ECHO                                        ����? �۾˾޾� . . .
) ELSE (
	ECHO                                      ��ũ��Ʈ �ʱ�ȭ�� . . .
)
ECHO.
ECHO.
ECHO  ������������������������������������������������������������������������������������������������
ECHO.
ECHO           ��� ^! Ÿ ����Ʈ/ī��/��α�/�䷻Ʈ ��� ����/���� �� ����� �̿� ���� ���� ^!
ECHO.
ECHO           ������ â�� ���߰ų� ����Ǵ� ���, ������ ^<3. ���� �ذ�^> ������ �������ּ���.
ECHO.
ECHO                                   Script by Virus Zero Season 2

DIR /B * >Nul 2>Nul
IF %ERRORLEVEL% NEQ 0 (
	SET ERRCODE=105
	GOTO MZK
)

FOR /F "DELIMS=" %%A IN ('TOOLS\DOFF\DOFF.EXE "yyyymmdd" -7 2^>Nul') DO (
	IF "%CURRENTDATE%" LEQ "%%A" SET DATECHK=1
)

REM * Check - Operating System Version
VER|TOOLS\GREP\GREP.EXE -Eiq "Version 6.0." >Nul 2>Nul
IF %ERRORLEVEL% EQU 0 SET OSVER=VISTA
VER|TOOLS\GREP\GREP.EXE -Eiq "Version 6.1." >Nul 2>Nul
IF %ERRORLEVEL% EQU 0 SET OSVER=7
VER|TOOLS\GREP\GREP.EXE -Eiq "Version 6.(2|3)." >Nul 2>Nul
IF %ERRORLEVEL% EQU 0 SET OSVER=8
VER|TOOLS\GREP\GREP.EXE -Eiq "Version 10.0." >Nul 2>Nul
IF %ERRORLEVEL% EQU 0 SET OSVER=10
IF /I "%OSVER%" == "NULL" (
	SET ERRCODE=100
	GOTO MZK
)

REM * Check - Current Directories
IF NOT DEFINED ALLUSERSPROFILE GOTO ERROR104
SET "MZKSYSTEMROOT=%SYSTEMROOT%"
SET "MZKSYSTEMROOT=%MZKSYSTEMROOT:(=^(%"
SET "MZKSYSTEMROOT=%MZKSYSTEMROOT:)=^)%"
SET "MZKSYSTEMROOT=%MZKSYSTEMROOT:&=^&%"
IF NOT DEFINED ALLUSERSPROFILE GOTO ERROR104
SET "MZKALLUSERSPROFILE=%ALLUSERSPROFILE%"
SET "MZKALLUSERSPROFILE=%MZKALLUSERSPROFILE:(=^(%"
SET "MZKALLUSERSPROFILE=%MZKALLUSERSPROFILE:)=^)%"
SET "MZKALLUSERSPROFILE=%MZKALLUSERSPROFILE:&=^&%"
IF NOT DEFINED USERPROFILE GOTO ERROR104
SET "MZKUSERPROFILE=%USERPROFILE%"
SET "MZKUSERPROFILE=%MZKUSERPROFILE:(=^(%"
SET "MZKUSERPROFILE=%MZKUSERPROFILE:)=^)%"
SET "MZKUSERPROFILE=%MZKUSERPROFILE:&=^&%"
IF NOT DEFINED APPDATA GOTO MZK_DS1X
SET "MZKAPPDATA=%APPDATA%"
SET "MZKAPPDATA=%MZKAPPDATA:(=^(%"
SET "MZKAPPDATA=%MZKAPPDATA:)=^)%"
SET "MZKAPPDATA=%MZKAPPDATA:&=^&%"
GOTO MZK_DS1Q
:MZK_DS1X
SET "APPDATA=%USERPROFILE%\AppData\Roaming"
SET "MZKAPPDATA=%MZKUSERPROFILE%\AppData\Roaming"
:MZK_DS1Q
IF NOT DEFINED LOCALAPPDATA GOTO MZK_DS2X
SET "LOCALLOWAPPDATA=%LOCALAPPDATA%Low"
SET "MZKLOCALAPPDATA=%LOCALAPPDATA%"
SET "MZKLOCALAPPDATA=%MZKLOCALAPPDATA:(=^(%"
SET "MZKLOCALAPPDATA=%MZKLOCALAPPDATA:)=^)%"
SET "MZKLOCALAPPDATA=%MZKLOCALAPPDATA:&=^&%"
SET "MZKLOCALLOWAPPDATA=%LOCALLOWAPPDATA%"
SET "MZKLOCALLOWAPPDATA=%MZKLOCALLOWAPPDATA:(=^(%"
SET "MZKLOCALLOWAPPDATA=%MZKLOCALLOWAPPDATA:)=^)%"
SET "MZKLOCALLOWAPPDATA=%MZKLOCALLOWAPPDATA:&=^&%"
GOTO MZK_DS2Q
:MZK_DS2X
SET "LOCALAPPDATA=%USERPROFILE%\AppData\Local"
SET "LOCALLOWAPPDATA=%USERPROFILE%\AppData\LocalLow"
SET "MZKLOCALAPPDATA=%MZKUSERPROFILE%\AppData\Local"
SET "MZKLOCALLOWAPPDATA=%MZKUSERPROFILE%\AppData\LocalLow"
:MZK_DS2Q
IF NOT DEFINED PUBLIC GOTO MZK_DS3X
SET "MZKPUBLIC=%PUBLIC%"
SET "MZKPUBLIC=%MZKPUBLIC:(=^(%"
SET "MZKPUBLIC=%MZKPUBLIC:)=^)%"
SET "MZKPUBLIC=%MZKPUBLIC:&=^&%"
GOTO MZK_DS3Q
:MZK_DS3X
SET "PUBLIC=%SYSTEMDRIVE%\Users\Public"
SET "MZKPUBLIC=%SYSTEMDRIVE%\Users\Public"
:MZK_DS3Q
IF NOT DEFINED PROGRAMFILES GOTO MZK_DS4X
SET "MZKPROGRAMFILES=%PROGRAMFILES%"
SET "MZKPROGRAMFILES=%MZKPROGRAMFILES:(=^(%"
SET "MZKPROGRAMFILES=%MZKPROGRAMFILES:)=^)%"
SET "MZKPROGRAMFILES=%MZKPROGRAMFILES:&=^&%"
GOTO MZK_DS4Q
:MZK_DS4X
SET "PROGRAMFILES=%SYSTEMDRIVE%\Program Files"
SET "MZKPROGRAMFILES=%SYSTEMDRIVE%\Program Files"
:MZK_DS4Q
IF NOT DEFINED PROGRAMFILES^(x86^) GOTO MZK_DS5X
SET "PROGRAMFILESX86=%PROGRAMFILES(x86)%"
SET "MZKPROGRAMFILESX86=%PROGRAMFILESX86%"
SET "MZKPROGRAMFILESX86=%MZKPROGRAMFILESX86:(=^(%"
SET "MZKPROGRAMFILESX86=%MZKPROGRAMFILESX86:)=^)%"
SET "MZKPROGRAMFILESX86=%MZKPROGRAMFILESX86:&=^&%"
GOTO MZK_DS5Q
:MZK_DS5X
SET "PROGRAMFILESX86=%SYSTEMDRIVE%\Program Files (x86)"
SET "MZKPROGRAMFILESX86=%SYSTEMDRIVE%\Program Files ^(x86^)"
:MZK_DS5Q
IF NOT DEFINED COMMONPROGRAMFILES GOTO MZK_DS6X
SET "MZKCOMMONPROGRAMFILES=%COMMONPROGRAMFILES%"
SET "MZKCOMMONPROGRAMFILES=%MZKCOMMONPROGRAMFILES:(=^(%"
SET "MZKCOMMONPROGRAMFILES=%MZKCOMMONPROGRAMFILES:)=^)%"
SET "MZKCOMMONPROGRAMFILES=%MZKCOMMONPROGRAMFILES:&=^&%"
GOTO MZK_DS6Q
:MZK_DS6X
SET "COMMONPROGRAMFILES=%SYSTEMDRIVE%\Program Files\Common Files"
SET "MZKCOMMONPROGRAMFILES=%SYSTEMDRIVE%\Program Files\Common Files"
:MZK_DS6Q
IF NOT DEFINED COMMONPROGRAMFILES^(x86^) GOTO MZK_DS7X
SET "COMMONPROGRAMFILESX86=%COMMONPROGRAMFILES(x86)%"
SET "MZKCOMMONPROGRAMFILESX86=%COMMONPROGRAMFILESX86%"
SET "MZKCOMMONPROGRAMFILESX86=%MZKCOMMONPROGRAMFILESX86:(=^(%"
SET "MZKCOMMONPROGRAMFILESX86=%MZKCOMMONPROGRAMFILESX86:)=^)%"
SET "MZKCOMMONPROGRAMFILESX86=%MZKCOMMONPROGRAMFILESX86:&=^&%"
GOTO MZK_DS7Q
:MZK_DS7X
SET "COMMONPROGRAMFILESX86=%SYSTEMDRIVE%\Program Files (x86)\Common Files"
SET "MZKCOMMONPROGRAMFILESX86=%SYSTEMDRIVE%\Program Files ^(x86^)\Common Files"
:MZK_DS7Q
IF NOT DEFINED TEMP SET "TEMP=%LOCALAPPDATA%\Temp"

REM * Check - Validate Directories
IF /I "%SYSTEMDRIVE%" == "%SYSTEMROOT%" SET ERRCODE=104
IF /I "%ALLUSERSPROFILE%" == "%SYSTEMROOT%" SET ERRCODE=104
IF /I "%USERPROFILE%" == "%SYSTEMROOT%" SET ERRCODE=104
IF /I "%APPDATA%" == "%SYSTEMROOT%" SET ERRCODE=104
IF /I "%LOCALAPPDATA%" == "%SYSTEMROOT%" SET ERRCODE=104
IF /I "%LOCALLOWAPPDATA%" == "%SYSTEMROOT%" SET ERRCODE=104
IF /I "%PUBLIC%" == "%SYSTEMROOT%" SET ERRCODE=104
IF /I "%PROGRAMFILES%" == "%SYSTEMROOT%" SET ERRCODE=104
IF /I "%PROGRAMFILESX86%" == "%SYSTEMROOT%" SET ERRCODE=104
IF /I "%COMMONPROGRAMFILES%" == "%SYSTEMROOT%" SET ERRCODE=104
IF /I "%COMMONPROGRAMFILESX86%" == "%SYSTEMROOT%" SET ERRCODE=104

REM * Check - Validate Temporary Directories
ECHO "%TEMP%"|TOOLS\GREP\GREP.EXE -Eixq "(\")[A-Z]:\\?(\")" >Nul 2>Nul
IF %ERRORLEVEL% EQU 0 SET ERRCODE=104
IF /I "%TEMP%" == "%SYSTEMDRIVE%" SET ERRCODE=104
IF /I "%TEMP%" == "%SYSTEMROOT%" SET ERRCODE=104
IF /I "%TEMP%" == "%SYSTEMROOT%\" SET ERRCODE=104
IF /I "%TEMP%" == "%ALLUSERSPROFILE%" SET ERRCODE=104
IF /I "%TEMP%" == "%ALLUSERSPROFILE%\" SET ERRCODE=104
IF /I "%TEMP%" == "%USERPROFILE%" SET ERRCODE=104
IF /I "%TEMP%" == "%USERPROFILE%\" SET ERRCODE=104
IF /I "%TEMP%" == "%APPDATA%" SET ERRCODE=104
IF /I "%TEMP%" == "%APPDATA%\" SET ERRCODE=104
IF /I "%TEMP%" == "%LOCALAPPDATA%" SET ERRCODE=104
IF /I "%TEMP%" == "%LOCALAPPDATA%\" SET ERRCODE=104
IF /I "%TEMP%" == "%LOCALLOWAPPDATA%" SET ERRCODE=104
IF /I "%TEMP%" == "%LOCALLOWAPPDATA%\" SET ERRCODE=104
IF /I "%TEMP%" == "%PUBLIC%" SET ERRCODE=104
IF /I "%TEMP%" == "%PUBLIC%\" SET ERRCODE=104
IF /I "%TEMP%" == "%PROGRAMFILES%" SET ERRCODE=104
IF /I "%TEMP%" == "%PROGRAMFILES%\" SET ERRCODE=104
IF /I "%TEMP%" == "%PROGRAMFILESX86%" SET ERRCODE=104
IF /I "%TEMP%" == "%PROGRAMFILESX86%\" SET ERRCODE=104
IF /I "%TEMP%" == "%COMMONPROGRAMFILES%" SET ERRCODE=104
IF /I "%TEMP%" == "%COMMONPROGRAMFILES%\" SET ERRCODE=104
IF /I "%TEMP%" == "%COMMONPROGRAMFILESX86%" SET ERRCODE=104
IF /I "%TEMP%" == "%COMMONPROGRAMFILESX86%\" SET ERRCODE=104
IF /I "%TEMP%" == "\" SET ERRCODE=104

IF %ERRCODE% NEQ 0 GOTO MZK

REM * Check - Administrator Privileges
AT.EXE >Nul 2>Nul
IF %ERRORLEVEL% NEQ 0 SET /A NUMTMP+=1
BCDEDIT.EXE >Nul 2>Nul
IF %ERRORLEVEL% NEQ 0 SET /A NUMTMP+=1
NET.EXE SESSION >Nul 2>Nul
IF %ERRORLEVEL% NEQ 0 SET /A NUMTMP+=1
MKDIR "%SYSTEMROOT%\System32\AdminAuthTest%RAND%" >Nul 2>Nul
IF %ERRORLEVEL% NEQ 0 (
	SET /A NUMTMP+=1
) ELSE (
	RMDIR "%SYSTEMROOT%\System32\AdminAuthTest%RAND%" >Nul 2>Nul
)
IF %NUMTMP% EQU 4 SET ERRCODE=103
SET NUMTMP=0

IF %ERRCODE% NEQ 0 GOTO MZK

REM * Check - Anti-Shutdown
SHUTDOWN.EXE /A >Nul 2>Nul

REM * Check - Database File Count
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F "DELIMS=" %%A IN ('DIR /S /A-D "DB\*.DB" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fi ".DB" 2^>Nul') DO SET /A NUMTMP+=1
IF !COUNT! NEQ !NUMTMP! (
	ENDLOCAL
	SET ERRCODE=107
	GOTO MZK
) ELSE (
	ENDLOCAL
)
SET NUMTMP=0

REM * Setup - Use Virtual Keyboard
IF /I "%1" == "VK" (
	SET VK=1
)

REM * Setup - Use Auto Mode
IF /I "%1" == "AUTO" (
	SET AUTOMODE=1
)

REM * Setup - Architecture
IF /I "%PROCESSOR_ARCHITECTURE%" == "AMD64" (
	SET ARCHITECTURE=x64
) ELSE (
	SET ARCHITECTURE=x86
)

REM * Setup - HashDeep Architecture
IF /I "%ARCHITECTURE%" == "x64" (
	SET MD5CHK=MD5DEEP64
	SET SHACHK=SHA256DEEP64
) ELSE (
	SET MD5CHK=MD5DEEP
	SET SHACHK=SHA256DEEP
)

REM * Setup - Database Initialization
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "DB\*.DB" 2^>Nul') DO (
	TOOLS\CRYPT\CRYPT.EXE -decrypt -key "%DBDATE%%CKEY%" -infile "DB\%%A" -outfile "DB_EXEC\%%A" >Nul 2>Nul
	TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "DB_EXEC\%%A" -ot file -actn ace -ace "n:Everyone;p:FILE_ADD_FILE;m:deny" -silent >Nul 2>Nul
)
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "DB\" 2^>Nul') DO (
	IF /I NOT "%%A" == "EXCEPT" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "DB\%%A\*.DB" 2^>Nul') DO (
			TOOLS\CRYPT\CRYPT.EXE -decrypt -key "%DBDATE%%CKEY%" -infile "DB\%%A\%%B" -outfile "DB_EXEC\%%A\%%B" >Nul 2>Nul
			TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "DB_EXEC\%%A\%%B" -ot file -actn ace -ace "n:Everyone;p:FILE_ADD_FILE;m:deny" -silent >Nul 2>Nul
		)
	)
)
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "DB\ACTIVESCAN\" 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "DB\ACTIVESCAN\%%A\*.DB" 2^>Nul') DO (
		TOOLS\CRYPT\CRYPT.EXE -decrypt -key "%DBDATE%%CKEY%" -infile "DB\ACTIVESCAN\%%A\%%B" -outfile "DB_EXEC\ACTIVESCAN\%%A\%%B" >Nul 2>Nul
		TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "DB_EXEC\ACTIVESCAN\%%A\%%B" -ot file -actn ace -ace "n:Everyone;p:FILE_ADD_FILE;m:deny" -silent >Nul 2>Nul
	)
)
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "DB\THREAT\" 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "DB\THREAT\%%A\*.DB" 2^>Nul') DO (
		TOOLS\CRYPT\CRYPT.EXE -decrypt -key "%DBDATE%%CKEY%" -infile "DB\THREAT\%%A\%%B" -outfile "DB_EXEC\THREAT\%%A\%%B" >Nul 2>Nul
		TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "DB_EXEC\THREAT\%%A\%%B" -ot file -actn ace -ace "n:Everyone;p:FILE_ADD_FILE;m:deny" -silent >Nul 2>Nul
	)
)
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "DB\EXCEPT\*.DB" 2^>Nul') DO (
	TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "DB\EXCEPT\%%A" -ot file -actn ace -ace "n:Everyone;p:FILE_ADD_FILE;m:deny" -silent >Nul 2>Nul
)
ATTRIB.EXE +R +H "DB_EXEC\*" /S /D >Nul 2>Nul

REM * Check - Required Files
IF NOT EXIST DB_EXEC\CHECK\CHK_REQUIREDFILES.DB (
	SET ERRCODE=101
	GOTO MZK
)
FOR /F "DELIMS=" %%A IN (DB_EXEC\CHECK\CHK_REQUIREDFILES.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		IF NOT EXIST "%%A" (
			SET "STRTMP=%%~nxA"
			SET ERRCODE=101
			GOTO MZK
		)
	)
)

REM * Check - Validate Required Files
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "DB_EXEC\*.DB" 2^>Nul') DO (
	FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "DB_EXEC\%%A" 2^>Nul') DO (
		FOR /F %%X IN ('ECHO "%%B|E\%%A"^|TOOLS\GREP\GREP.EXE -Fxvf TOOLS\000.005 2^>Nul') DO (
			SET ERRCODE=107
			GOTO MZK
		)
	)
)
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "DB_EXEC\" 2^>Nul') DO (
	IF /I NOT "%%A" == "EXCEPT" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "DB_EXEC\%%A\*.DB" 2^>Nul') DO (
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "DB_EXEC\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('ECHO "%%C|E\%%A\%%B"^|TOOLS\GREP\GREP.EXE -Fxvf TOOLS\000.005 2^>Nul') DO (
					SET ERRCODE=107
					GOTO MZK
				)
			)
		)
	)
)
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "DB_EXEC\ACTIVESCAN\" 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "DB_EXEC\ACTIVESCAN\%%A\*.DB" 2^>Nul') DO (
		FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "DB_EXEC\ACTIVESCAN\%%A\%%B" 2^>Nul') DO (
			FOR /F %%X IN ('ECHO "%%C|E\AS\%%A\%%B"^|TOOLS\GREP\GREP.EXE -Fxvf TOOLS\000.005 2^>Nul') DO (
				SET ERRCODE=107
				GOTO MZK
			)
		)
	)
)
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "DB_EXEC\THREAT\" 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "DB_EXEC\THREAT\%%A\*.DB" 2^>Nul') DO (
		FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "DB_EXEC\THREAT\%%A\%%B" 2^>Nul') DO (
			FOR /F %%X IN ('ECHO "%%C|E\TH\%%A\%%B"^|TOOLS\GREP\GREP.EXE -Fxvf TOOLS\000.005 2^>Nul') DO (
				SET ERRCODE=107
				GOTO MZK
			)
		)
	)
)
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "*" 2^>Nul') DO (
	FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%%A" 2^>Nul') DO (
		IF /I NOT "%%~xA" == ".TXT" (
			FOR /F %%X IN ('ECHO "%%B|XXX\%%A"^|TOOLS\GREP\GREP.EXE -Fxvf TOOLS\000.005 2^>Nul') DO (
				SET ERRCODE=107
				GOTO MZK
			)
		)
	)
)
FOR /F "DELIMS=" %%A IN ('DIR /S /B /A-D "TOOLS\*" 2^>Nul') DO (
	FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%%A" 2^>Nul') DO (
		IF /I NOT "%%~xA" == ".TXT" (
			IF /I NOT "%%~xA" == ".XML" (
				IF /I NOT "%%~nxA" == "000.005" (
					FOR /F %%X IN ('ECHO "%%B|TOOLS\%%~nxA"^|TOOLS\GREP\GREP.EXE -Fxvf TOOLS\000.005 2^>Nul') DO (
						SET ERRCODE=107
						GOTO MZK
					)
				)
			)
		)
	)
)
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "DB\EXCEPT\*.DB" 2^>Nul') DO (
	FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "DB\EXCEPT\%%A" 2^>Nul') DO (
		FOR /F %%X IN ('ECHO "%%B|X\%%A"^|TOOLS\GREP\GREP.EXE -Fxvf TOOLS\000.005 2^>Nul') DO (
			SET ERRCODE=107
			GOTO MZK
		)
	)
)

REM * Check - Malicious Command-Line Autorun
FOR /F "TOKENS=2,*" %%A IN ('TOOLS\000.000 QUERY "HKCU\Software\Microsoft\Command Processor" /v AutoRun 2^>Nul^|TOOLS\GREP\GREP.EXE -Ei "[[:space:]]REG_(SZ|(EXPAND|MULTI)_SZ|(D|Q)WORD|BINARY|NONE)[[:space:]]" 2^>Nul') DO (
	SETLOCAL ENABLEDELAYEDEXPANSION
	ECHO "%%B"|TOOLS\GREP\GREP.EXE -Fiq "WINDOWS\IEUPDATE" >Nul 2>Nul
	IF !ERRORLEVEL! EQU 0 (
		ENDLOCAL
		TOOLS\000.000 DELETE "HKCU\Software\Microsoft\Command Processor" /v AutoRun /f >Nul 2>Nul
	) ELSE (
		ENDLOCAL
	)
)

REM * Check - Image File Execution Options
FOR /F "DELIMS=" %%A IN (DB_EXEC\CHECK\CHK_REQUIREDFILES_IMGFILEEXECOP.DB) DO (
	IF /I NOT "%%~nxA" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		SETLOCAL ENABLEDELAYEDEXPANSION
		TOOLS\000.000 DELETE "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%~nxA" /f >Nul 2>Nul
		IF !ERRORLEVEL! NEQ 0 (
			ENDLOCAL
			TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%~nxA" -ot reg -actn clear -clr "dacl,sacl" -actn setprot -op "dacl:np;sacl:np" -rec yes -actn setowner -ownr "n:Administrators" -actn rstchldrn -rst "dacl,sacl" -silent >Nul 2>Nul
			TOOLS\000.000 DELETE "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%~nxA" /f >Nul 2>Nul
		) ELSE (
			ENDLOCAL
		)
		IF /I "%ARCHITECTURE%" == "x64" (
			SETLOCAL ENABLEDELAYEDEXPANSION
			TOOLS\000.000 DELETE "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%~nxA" /f >Nul 2>Nul
			IF !ERRORLEVEL! NEQ 0 (
				ENDLOCAL
				TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%~nxA" -ot reg -actn clear -clr "dacl,sacl" -actn setprot -op "dacl:np;sacl:np" -rec yes -actn setowner -ownr "n:Administrators" -actn rstchldrn -rst "dacl,sacl" -silent >Nul 2>Nul
				TOOLS\000.000 DELETE "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%~nxA" /f >Nul 2>Nul
			) ELSE (
				ENDLOCAL
			)
		)
	)
)

REM * Repair - Required Files
FOR /F "DELIMS=" %%A IN (DB_EXEC\CHECK\CHK_REQUIREDFILES_SYSTEM.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		IF NOT EXIST "%SYSTEMROOT%\System32\%%A" (
			COPY /Y "%SYSTEMROOT%\System32\DllCache\%%A" "%SYSTEMROOT%\System32\" >Nul 2>Nul
			IF NOT EXIST "%SYSTEMROOT%\System32\%%A" (
				SET "STRTMP=%SYSTEMROOT%\System32\%%A"
				SET ERRCODE=102
				GOTO MZK
			)
		)
	)
)

REM * Check - Malicious Service Stop
REM :HKLM\System\CurrentControlSet\Services\6to4\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\6to4\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "6TO4SVC.DLL" (
		SC.EXE STOP "6to4" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\AeLookupSvc\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\AeLookupSvc\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "AELUPSVC.DLL" (
		SC.EXE STOP "AeLookupSvc" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\Appinfo\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Appinfo\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "APPINFO.DLL" (
		SC.EXE STOP "Appinfo" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\AppMgmt\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\AppMgmt\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "APPMGMTS.DLL" (
		SC.EXE STOP "AppMgmt" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\BITS\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\BITS\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "QMGR.DLL" (
		SC.EXE STOP "BITS" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\Browser\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Browser\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "BROWSER.DLL" (
		SC.EXE STOP "Browser" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\dmserver\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\dmserver\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "DMSERVER.DLL" (
		SC.EXE STOP "dmserver" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\DsmSvc\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\DsmSvc\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "DEVICESETUPMANAGER.DLL" (
		SC.EXE STOP "DsmSvc" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\Emproxy (ImagePath)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Emproxy\ImagePath" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "EMPROXY.EXE" (
		SC.EXE STOP "Emproxy" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\FastUserSwitchingCompatibility\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\FastUserSwitchingCompatibility\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "SHSVCS.DLL" (
		SC.EXE STOP "FastUserSwitchingCompatibility" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\Ias\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Ias\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IAS.DLL" (
		SC.EXE STOP "Ias" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\IKEEXT\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\IKEEXT\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IKEEXT.DLL" (
		SC.EXE STOP "IKEEXT" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\Irmon\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Irmon\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IRMON.DLL" (
		SC.EXE STOP "Irmon" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\MSiSCSI\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\MSiSCSI\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "ISCSIEXE.DLL" (
		SC.EXE STOP "MSiSCSI" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\NWCWorkstation\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\NWCWorkstation\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "NWWKS.DLL" (
		SC.EXE STOP "NWCWorkstation" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ip (DllPath)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ip\DllPath" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IPRTRMGR.DLL" (
		SC.EXE STOP "RemoteAccess" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ipv6 (DllPath)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ipv6\DllPath" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IPRTRMGR.DLL" (
		SC.EXE STOP "RemoteAccess" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ipx (DllPath)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ipx\DllPath" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IPXRTMGR.DLL" (
		SC.EXE STOP "RemoteAccess" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\Schedule\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Schedule\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "SCHEDSVC.DLL" (
		SC.EXE STOP "Schedule" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\StiSvc\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\StiSvc\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "WIASERVC.DLL" (
		SC.EXE STOP "StiSvc" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\SuperProServer (ImagePath)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\SuperProServer\ImagePath" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "SPNSRVNT.EXE" (
		SC.EXE STOP "SuperProServer" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\TermService\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\TermService\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "TERMSRV.DLL" (
		IF /I NOT "%%~nxA" == "RDPWRAP.DLL" (
			SC.EXE STOP "TermService" >Nul 2>Nul
		)
	)
)
REM :HKLM\System\CurrentControlSet\Services\UxSms\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\UxSms\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "UXSMS.DLL" (
		SC.EXE STOP "UxSms" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\Winmgmt\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Winmgmt\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "WMISVC.DLL" (
		SC.EXE STOP "Winmgmt" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\WmdmPmSN\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\WmdmPmSN\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "MSPMSNSV.DLL" (
		SC.EXE STOP "WmdmPmSN" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\WmdmPmSp\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\WmdmPmSp\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "MSPMSPSV.DLL" (
		SC.EXE STOP "WmdmPmSp" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\wuauserv\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\wuauserv\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "WUAUENG.DLL" (
		SC.EXE STOP "wuauserv" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\xmlprov\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\xmlprov\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "XMLPROV.DLL" (
		SC.EXE STOP "xmlprov" >Nul 2>Nul
	)
)

REG.EXE QUERY HKLM >Nul 2>Nul
IF %ERRORLEVEL% NEQ 0 (
	SET ERRCODE=106
	GOTO MZK
)

IF EXIST D:\MZKTEMP DEL /F /Q /A D:\MZKTEMP >Nul 2>Nul
COPY DB_ACTIVE\MZK D:\MZKTEMP >Nul 2>Nul
IF EXIST D:\MZKTEMP (
	SET DDRV=TRUE
	DEL /F /Q /A D:\MZKTEMP >Nul 2>Nul
)

REM * Reset - Count Value (All)
CALL :RESETVAL ALL

:MZK
COLOR 1F

CLS

REM * Start
ECHO ������������������������������������������������������������������������������������������������
ECHO.
ECHO      Malware Zero Kit  ^[DB: %DBDATE% V%DBVER%^]
ECHO.
ECHO      Virus Zero Season 2 : cafe.naver.com/malzero
ECHO.     Batch Script : ViOLeT ^(archguru^)
ECHO.
ECHO      ��� ^! Ÿ ����Ʈ/ī��/��α�/�䷻Ʈ ��� ����/���� �� ����� �̿� ���� ���� ^!
ECHO.
ECHO ������������������������������������������������������������������������������������������������
ECHO.

REM * Check - Error Code
IF %ERRCODE% EQU 100 GOTO FAILEDOS
IF %ERRCODE% EQU 101 GOTO NOFILE
IF %ERRCODE% EQU 102 GOTO NOSYSF
IF %ERRCODE% EQU 103 GOTO FAILED
IF %ERRCODE% EQU 104 GOTO NOVAR
IF %ERRCODE% EQU 105 GOTO MALWARE
IF %ERRCODE% EQU 106 GOTO REGBLOCK
IF %ERRCODE% EQU 107 GOTO NOCOUNT

ECHO �� �˻� ���� ���� �ݵ�� �о��ּ��� ^!
ECHO.
ECHO    �˻� ���� ��, �������� ���α׷��� ��� �����ϹǷ� �۾����� ���� �ݵ�� �������ּ���.
ECHO.
ECHO    �ش� ��ũ��Ʈ�� ��Ȱ�� �˻縦 ���� ���� ��� ȯ�濡���� ������ �����մϴ�. ^(�ʼ� �ƴ�^)
ECHO    ǥ�� ȯ�濡���� �Ǽ��ڵ忡 ���� ���� ����� �Ǵ� ��� ��ũ���� �߻��� �� �ֽ��ϴ�.
ECHO    ^(�Ǽ��ڵ� ������ ���� ġ�� ��, ���� ��ֳ� ������ ���� ���ۿ� �߻� ���ɼ� ����^)
ECHO.
ECHO    �� ��ũ��Ʈ�� �Ǽ� ��ƮŶ^(Rootkit^), ���� ������ �Ǽ��ڵ� �� ���� ���� ���α׷��� �����մϴ�.
ECHO    �� ��ũ��Ʈ�� �˻� �� ���� ��� �� �ӽ� ������ �ڵ����� �����ϸ�, ���� �߻� �� �����ּ���.
ECHO    �� ��ũ��Ʈ�� ���� ��ǰ�� �ǽð� ���� ����� ���� ���� ���, �˻� �ð��� ������ �� �ֽ��ϴ�.
ECHO    �� ��ũ��Ʈ�� ���� �������� �����Ǿ�� �ϸ�, �ʿ��� ��쿡�� ������ֽñ� �ٶ��ϴ�.
ECHO.
ECHO    ��ũ��Ʈ ��� �� �ݵ�� ���� ��ǰ^(���^)�� �̿��Ͽ� ���� �˻縦 �������ּ���.
ECHO.
ECHO    ���� �� â�� �����ų� �˻� �� ��ð� �������� ������ ^<3. ���� �ذ�^> ������ �������ּ���.
ECHO.

PING.EXE -n 2 0 >Nul 2>Nul

IF %VK% EQU 1 START TOOLS\MAGNETOK\MAGNETOK.EXE >Nul 2>Nul

IF %AUTOMODE% EQU 1 (
	ECHO �� �� 1�� �Ŀ� �ڵ����� �˻縦 �����մϴ�. ������ ������ �����ø� �������ּ��� . . .

	PING.EXE -n 60 0 >Nul 2>Nul

	SET YNAAA=Y
) ELSE (
	SET /P YNAAA="�� ����: ���� �� �˻縦 �����Ͻðڽ��ϱ� (Y/N)? "
)
IF /I NOT "%YNAAA%" == "��" (
	IF /I NOT "%YNAAA%" == "Y" (
		SET ERRCODE=999
		GOTO END
	)
)

IF %DATECHK% EQU 1 (
	COLOR 6F
	ECHO.
	ECHO �� ��� ^! �����ͺ��̽�^(DB^) ������ �����Ǿ� �Ǽ� ���α׷��� ȿ�������� ������ �� �����ϴ�.
	ECHO.
	ECHO    ���� ������� ��ũ��Ʈ�� ���� ��, ���� �����޾� �˻縦 �������ֽñ� �ٶ��ϴ�.
	IF %AUTOMODE% NEQ 1 (
		ECHO.
		SET /P YNBBB="�� ����: ��� �����Ͻðڽ��ϱ� (Y/N)? "
	) ELSE (
		SET YNBBB=Y
	)
) ELSE (
	SET YNBBB=Y
)
IF /I NOT "%YNBBB%" == "��" (
	IF /I NOT "%YNBBB%" == "Y" (
		SET ERRCODE=999
		GOTO END
	)
)

ECHO.

IF %AUTOMODE% NEQ 1 (
	ECHO �� �Ǽ� ���α׷� �� �Ǽ��ڵ带 ȿ�������� �����ϱ� ���� Windows Ž���⸦ �����մϴ�.
	ECHO.
	ECHO    ���� �� �˻� �Ϸ� �� ���� ���� ȭ���� ��Ȱ��ȭ �Ǹ�, ���� ����/�̵�/���� �۾��� ��ҵ˴ϴ�.
	ECHO.
	ECHO    ����, ������ ���� ������ ���� ����� ������ ���α׷� ���� �� ���� �� ������ �߻��ϹǷ�
	ECHO    �˻� �Ϸ� �� �ݵ�� ������� �������ֽñ� �ٶ��ϴ�.
	ECHO.
	ECHO    ���� ��, �˻� �� â�� �����ų� ��ð� �������� ������ CTRL ^+ ALT ^+ DEL Ű�� ���ÿ� ��������.
	ECHO    ����, ���� ��ư �� �޴��� ���� ����� �� ^<3. ���� �ذ�^> ������ �������ּ���.
	ECHO.

	SET /P YNCCC="�� ����: Windows Ž���⸦ �����Ͻðڽ��ϱ� (Y/N)? "

	ECHO.
) ELSE (
	SET YNCCC=N
)
IF /I NOT "%YNCCC%" == "��" (
	IF /I "%YNCCC%" == "Y" (
		SET CHKEXPLORER=1
		TOOLS\TASKS\TASKKILL.EXE /F /IM "EXPLORER.EXE" >Nul 2>Nul
	)
)

SCHTASKS.EXE /End /TN "\Microsoft\Windows\TextServicesFramework\MsCtfMonitor" >Nul 2>Nul
SCHTASKS.EXE /End /TN "\Microsoft\Windows\Multimedia\SystemSoundsService" >Nul 2>Nul

TOOLS\TASKS\TASKKILL.EXE /IM "CSCRIPT.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /IM "DLLHOST.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /IM "RUNDLL32.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /IM "SCHTASKS.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /IM "WSCRIPT.EXE" >Nul 2>Nul

TOOLS\TASKS\TASKKILL.EXE /F /IM "CSCRIPT.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /F /IM "DLLHOST.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /F /IM "RUNDLL32.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /F /IM "SCHTASKS.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /F /IM "WSCRIPT.EXE" >Nul 2>Nul

SET "STRTMP=%DATE% %TIME%"

SET "RPTDATE=%STRTMP:-=%"
SET "RPTDATE=%RPTDATE:/=%"
SET "RPTDATE=%RPTDATE::=%"
SET "RPTDATE=%RPTDATE:.=%"
SET "RPTDATE=%RPTDATE: =%"

REM * Setup - Quarantine
MKDIR "%SYSTEMDRIVE%\Quarantine_MZK" >Nul 2>Nul
MKDIR "%SYSTEMDRIVE%\Quarantine_MZK\Files" >Nul 2>Nul
MKDIR "%SYSTEMDRIVE%\Quarantine_MZK\Folders" >Nul 2>Nul
MKDIR "%SYSTEMDRIVE%\Quarantine_MZK\Registrys" >Nul 2>Nul
MKDIR "%SYSTEMDRIVE%\Quarantine_MZK\Files\%RPTDATE%" >Nul 2>Nul
MKDIR "%SYSTEMDRIVE%\Quarantine_MZK\Folders\%RPTDATE%" >Nul 2>Nul
MKDIR "%SYSTEMDRIVE%\Quarantine_MZK\Registrys\%RPTDATE%" >Nul 2>Nul

SET "QRoot=%SYSTEMDRIVE%\Quarantine_MZK"
SET "QFiles=%QRoot%\Files\%RPTDATE%"
SET "QFolders=%QRoot%\Folders\%RPTDATE%"
SET "QRegistrys=%QRoot%\Registrys\%RPTDATE%"

TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "%QFiles%" -ot file -actn ace -ace "n:Everyone;p:FILE_TRAVERSE;m:deny" -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "%QFolders%" -ot file -actn ace -ace "n:Everyone;p:FILE_TRAVERSE;m:deny" -silent >Nul 2>Nul

SET "QLog=%QRoot%\Report [%RPTDATE%].mzk.log"

REM * Setup - Start Logging
ECHO �� �˻� ��� ���� �� �Ǽ��ڵ� �ݸ��� ���� �˿��� ���� . . .
ECHO    �˻� �Ͻ� : %STRTMP%
ECHO    �˿��� ���� : %QRoot%
ECHO    ��� : %QLog%

>>"%QLog%" ECHO Malware Zero Kit Report File
>>"%QLog%" ECHO.
>>"%QLog%" ECHO -- ��� --
>>"%QLog%" ECHO.
>>"%QLog%" ECHO    �����ͺ��̽��� �ڵ����� ���ŵ��� �ʱ� ������, �ʿ��� ������ ���� �����޾� �˻��Ͻñ� �ٶ��ϴ�.
>>"%QLog%" ECHO    ������ �����ͺ��̽��δ� �ű� �Ǽ� ���α׷��� ������ �� �����ϴ�.
>>"%QLog%" ECHO.
>>"%QLog%" ECHO -- �˸� --
>>"%QLog%" ECHO.
>>"%QLog%" ECHO    ��ũ��Ʈ ��� ��, �Ʒ� ���� �ݵ�� Ȯ��
>>"%QLog%" ECHO.
>>"%QLog%" ECHO    �� �Ǽ��ڵ� ���ſ� �������� ���, ���� ��忡�� �˻縦 �����ϰų� ����� �� ��˻� ����
>>"%QLog%" ECHO    �� �޸𸮸� Ȱ���ϴ� �Ǽ��ڵ忡 �����Ǿ��� ���, �˻� �� �ݵ�� ����� ����
>>"%QLog%" ECHO    �� �� ���������� �Ǽ� ���� â�� ������ ���, ������ ���� �� �ΰ�/Ȯ�� ���α׷� ���� �� �缳ġ
>>"%QLog%" ECHO    �� �ѱ� �Է� �Ұ� �� Ư�� ���α׷�^(��^: Classic Shell^)�� ���� ������� ���� ��� ����� ����
>>"%QLog%" ECHO    �� ����� ��ũ��Ʈ�� �������� ���� ���, ����� �� ���� ����
>>"%QLog%" ECHO    �� �˻� �� ��Ʈ��ũ�� ������� ���� ���, ^<3. ���� �ذ�^> ���� ^<���� 07^> �׸� ����
>>"%QLog%" ECHO    �� �˻� �� ���� �� �������� �߻��Ѵٸ� ^<3. ���� �ذ�^> ���� ^<���� 05^> �׸� ����
>>"%QLog%" ECHO.
>>"%QLog%" ECHO    �Ǽ��ڵ� ���� ��, ���� ��ǰ^(���^)�� ���� �������� �ʴ� ��Ȳ�� ���ӵ� ��� �Ʒ� ���� Ȯ��
>>"%QLog%" ECHO.
>>"%QLog%" ECHO    �� �ֵ���� �� ���ʿ� �� ���� ���� ���α׷��� ���� �� �ٽ� �˻�^(�߿�^)
>>"%QLog%" ECHO    �� ���� ��ü���� �����ϴ� ���� ��� �߰� ���
>>"%QLog%" ECHO    �� �������� �ʴ� ���� ��ǰ ���� �� ����� �� ��ġ ���� ���� �����ޱ� �� �缳ġ
>>"%QLog%" ECHO.
>>"%QLog%" ECHO    �� �ڱ� �ڽź��� ���� ��õ ^! ^! ^! ^<5. �Ǽ��ڵ� ���� ����^> ���� ����
>>"%QLog%" ECHO.
>>"%QLog%" ECHO    �� �Ǽ��ڵ� �м� ��û �� ^<3. ���� �ذ�^> ���� ^<���� 17^> �׸� ����
>>"%QLog%" ECHO.
>>"%QLog%" ECHO -- �˻� ���� --
>>"%QLog%" ECHO.
>>"%QLog%" ECHO    �����ͺ��̽� ���� : %DBDATE% V%DBVER%
>>"%QLog%" ECHO.
FOR /F "DELIMS=" %%A IN ('VER 2^>Nul') DO (
	>>"%QLog%" ECHO    �ü��^(OS^) : %%A, %ARCHITECTURE%
)
IF NOT DEFINED SAFEBOOT_OPTION (
	>>"%QLog%" ECHO    �˻� ȯ�� : ǥ��
) ELSE (
	IF /I "%SAFEBOOT_OPTION%" == "MINIMAL" (
		>>"%QLog%" ECHO    �˻� ȯ�� : ���� ���
	) ELSE (
		IF /I "%SAFEBOOT_OPTION%" == "NETWORK" (
			>>"%QLog%" ECHO    �˻� ȯ�� : ���� ��� ^(��Ʈ��ŷ ���^)
		) ELSE (
			>>"%QLog%" ECHO    �˻� ȯ�� : ���� ��� ^(��Ÿ^)
		)
	)
)
>>"%QLog%" ECHO    �˻� �Ͻ� : %STRTMP%
IF %VK% EQU 1 (
	>>"%QLog%" ECHO    �˻� ���� : ���� Ű����
) ELSE (
	IF %AUTOMODE% EQU 1 (
		>>"%QLog%" ECHO    �˻� ���� : �ڵ�
	) ELSE (
		>>"%QLog%" ECHO    �˻� ���� : ���ڵ�
	)
)
>>"%QLog%" ECHO.
>>"%QLog%" ECHO    �˿��� ���� : %QRoot%
>>"%QLog%" ECHO.

SET STRTMP=NULL

PING.EXE -n 4 0 >Nul 2>Nul

ECHO.

REM * Check - User Account Control
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System\EnableLUA" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%A" == "1" (
		>>"%QLog%" ECHO -- ����� ���� ��Ʈ��^(UAC^) --
		>>"%QLog%" ECHO.
		>>"%QLog%" ECHO    �� ���� �� ����� ���� ��Ʈ��^(UAC^) ����� ��Ȱ��ȭ �Ǿ� �ֽ��ϴ�.
		>>"%QLog%" ECHO.

		ECHO �� ���� �� ����� ���� ��Ʈ��^(UAC^) ����� ��Ȱ��ȭ �Ǿ� �ֽ��ϴ�.
		ECHO.
		>VARIABLE\XXYY ECHO 1
	) ELSE (
		>>"%QLog%" ECHO -- ����� ���� ��Ʈ��^(UAC^) --
		>>"%QLog%" ECHO.
		>>"%QLog%" ECHO    �� ���� �� ����� ���� ��Ʈ��^(UAC^) ����� Ȱ��ȭ �Ǿ� �ֽ��ϴ�.
		>>"%QLog%" ECHO.
	)
)

>>"%QLog%" ECHO -- �� ���� --
>>"%QLog%" ECHO.

REM * Check - Required System Files
ECHO �� �ʼ� �ý��� ���� ���� ��/�� Ȯ���� . . . & >>"%QLog%" ECHO    �� �ʼ� �ý��� ���� ���� ��/�� Ȯ�� :
FOR /F "TOKENS=1,2,3 DELIMS=|" %%A IN (DB_EXEC\CHECK\CHK_SYSTEMFILE.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		IF EXIST "DB_EXEC\MD5CHK\CHK_MD5_%%A.DB" (
			>VARIABLE\TXT2 ECHO %%A
			TITLE Ȯ���� "%%A" 2>Nul
			IF %%B EQU 1 (
				>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%
				CALL :CHK_SYSF
			) ELSE (
				IF %%C EQU 1 (
					IF /I "%ARCHITECTURE%" == "x64" (
						>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64
					) ELSE (
						>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32
					)
					CALL :CHK_SYSF
				) ELSE (
					IF /I "%ARCHITECTURE%" == "x64" (
						>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64
						CALL :CHK_SYSF
					)
					>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32
					CALL :CHK_SYSF
				)
			)
		)
	)
)
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\SRCH SET /P SRCH=
IF !SRCH! EQU 0 (
	ENDLOCAL
	ECHO    �������� �ʴ� ������ �����ϴ�. & >>"%QLog%" ECHO    �������� �ʴ� ������ ����
	SET "YNCCC=Y"
) ELSE (
	ENDLOCAL
	>VARIABLE\XXXX ECHO 1
	IF %AUTOMODE% EQU 1 (
		ECHO.
		ECHO �� �ʼ� �ý��� ������ �������� �ʾ�, ���̻� �ڵ����� ������ �� �����ϴ�.
		ECHO.
		SET "YNCCC=N"
	) ELSE (
		ECHO.
		ECHO �� �ʼ� �ý��� ������ �������� �ʾ�, ������ ���� ���� ���� �� �˻��ϴ� ���� �����մϴ�.
		ECHO.
		SET /P YNCCC="�� ����: �˻縦 ��� �����Ͻðڽ��ϱ� (Y/N)? "
	)
)
IF /I NOT "%YNCCC%" == "��" (
	IF /I NOT "%YNCCC%" == "Y" (
		SET ERRCODE=999
		GOTO END
	)
)

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Reset - Malicious AppInit_DLLs Values (x64 or x86)
ECHO �� �Ǽ� �� ���� ���� �ڵ� ���� ���̺귯��^(AppInit_DLLs^) �� Ȯ���� . . . & >>"%QLog%" ECHO    �� �Ǽ� �� ���� ���� �ڵ� ���� ���̺귯��^(AppInit_DLLs^) �� Ȯ�� :
TITLE ^(Ȯ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%Z IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Windows\AppInit_DLLs" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	SET "REGTMP=%%Z"
	SETLOCAL ENABLEDELAYEDEXPANSION
	SET "REGTMP=!REGTMP:"=!"
	FOR /F "TOKENS=1,2,3,4,5 DELIMS=," %%A IN ("!REGTMP!") DO (
		IF NOT "%%~nxA" == "" (
			IF /I "%%~xA" == ".TXT" (
				>>VARIABLE\RGST ECHO "FAKETEXT"
			) ELSE (
				>>VARIABLE\RGST ECHO "%%~nxA"
			)
		)
		IF NOT "%%~nxB" == "" (
			IF /I "%%~xB" == ".TXT" (
				>>VARIABLE\RGST ECHO "FAKETEXT"
			) ELSE (
				>>VARIABLE\RGST ECHO "%%~nxB"
			)
		)
		IF NOT "%%~nxC" == "" (
			IF /I "%%~xC" == ".TXT" (
				>>VARIABLE\RGST ECHO "FAKETEXT"
			) ELSE (
				>>VARIABLE\RGST ECHO "%%~nxC"
			)
		)
		IF NOT "%%~nxD" == "" (
			IF /I "%%~xD" == ".TXT" (
				>>VARIABLE\RGST ECHO "FAKETEXT"
			) ELSE (
				>>VARIABLE\RGST ECHO "%%~nxD"
			)
		)
		IF NOT "%%~nxE" == "" (
			IF /I "%%~xE" == ".TXT" (
				>>VARIABLE\RGST ECHO "FAKETEXT"
			) ELSE (
				>>VARIABLE\RGST ECHO "%%~nxE"
			)
		)
	)
	ENDLOCAL
)
FOR /F "DELIMS=" %%A IN (VARIABLE\RGST) DO (
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%~A" DB_EXEC\CHECK\CHK_APPINIT_DLLS.DB 2^>Nul') DO (
		SETLOCAL ENABLEDELAYEDEXPANSION
		>VARIABLE\CHCK ECHO 1
		REG.EXE EXPORT "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Windows" "!QRegistrys!\HKLM_WinNT_Windows.reg" /y >Nul 2>Nul
		REG.EXE ADD "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Windows" /v AppInit_DLLs /d "" /f >Nul 2>Nul
		IF !ERRORLEVEL! EQU 0 (
			ECHO    ������ ���� �߰ߵǾ� �ʱ�ȭ�� �����մϴ�. ^(����� �ʿ�^) & >>"!QLog!" ECHO    ������ ���� �߰ߵǾ� �ʱ�ȭ ���� ^(����� �ʿ�^)
		) ELSE (
			ECHO    ������ ���� �߰ߵǾ� �ʱ�ȭ�� �����Ͽ����� ������ �߻��߽��ϴ�. & >>"!QLog!" ECHO    ������ ���� �߰ߵǾ� �ʱ�ȭ ���� ^(���� - ���� �߻�^)
		)
		ENDLOCAL & GOTO GO_INIT1
	)
)
:GO_INIT1
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\CHCK SET /P CHCK=
IF !CHCK! EQU 0 (
	ENDLOCAL
	ECHO    �������� �߰ߵ��� �ʾҽ��ϴ�. & >>"%QLog%" ECHO    �������� �߰ߵ��� ����
) ELSE (
	ENDLOCAL
	>VARIABLE\XXXX ECHO 1 & COLOR 4F
)
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Reset - Malicious AppInit_DLLs Values (x86)
IF /I "%ARCHITECTURE%" == "x64" (
	ECHO �� �Ǽ� �� ���� ���� �ڵ� ���� ���̺귯��^(AppInit_DLLs, 32bit^) �� Ȯ���� . . . & >>"%QLog%" ECHO    �� �Ǽ� �� ���� ���� �ڵ� ���� ���̺귯��^(AppInit_DLLs, 32bit^) �� Ȯ�� :
	TITLE ^(Ȯ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
	FOR /F "TOKENS=2,*" %%Y IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows\AppInit_DLLs" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
		SET "REGTMP=%%Z"
		SETLOCAL ENABLEDELAYEDEXPANSION
		SET "REGTMP=!REGTMP:"=!"
		FOR /F "TOKENS=1,2,3,4,5 DELIMS=," %%A IN ("!REGTMP!") DO (
			IF NOT "%%~nxA" == "" (
				IF /I "%%~xA" == ".TXT" (
					>>VARIABLE\RGST ECHO "FAKETEXT"
				) ELSE (
					>>VARIABLE\RGST ECHO "%%~nxA"
				)
			)
			IF NOT "%%~nxB" == "" (
				IF /I "%%~xB" == ".TXT" (
					>>VARIABLE\RGST ECHO "FAKETEXT"
				) ELSE (
					>>VARIABLE\RGST ECHO "%%~nxB"
				)
			)
			IF NOT "%%~nxC" == "" (
				IF /I "%%~xC" == ".TXT" (
					>>VARIABLE\RGST ECHO "FAKETEXT"
				) ELSE (
					>>VARIABLE\RGST ECHO "%%~nxC"
				)
			)
			IF NOT "%%~nxD" == "" (
				IF /I "%%~xD" == ".TXT" (
					>>VARIABLE\RGST ECHO "FAKETEXT"
				) ELSE (
					>>VARIABLE\RGST ECHO "%%~nxD"
				)
			)
			IF NOT "%%~nxE" == "" (
				IF /I "%%~xE" == ".TXT" (
					>>VARIABLE\RGST ECHO "FAKETEXT"
				) ELSE (
					>>VARIABLE\RGST ECHO "%%~nxE"
				)
			)
		)
		ENDLOCAL
	)
	FOR /F "DELIMS=" %%A IN (VARIABLE\RGST) DO (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%~A" DB_EXEC\CHECK\CHK_APPINIT_DLLS.DB 2^>Nul') DO (
			SETLOCAL ENABLEDELAYEDEXPANSION
			>VARIABLE\CHCK ECHO 1
			REG.EXE EXPORT "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows" "!QRegistrys!\HKLM_WinNT_Windows(x86).reg" /y >Nul 2>Nul
			REG.EXE ADD "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows" /v AppInit_DLLs /d "" /f >Nul 2>Nul
			IF !ERRORLEVEL! EQU 0 (
				ECHO    ������ ���� �߰ߵǾ� �ʱ�ȭ�� �����մϴ�. ^(����� �ʿ�^) & >>"!QLog!" ECHO    ������ ���� �߰ߵǾ� �ʱ�ȭ ���� ^(����� �ʿ�^)
			) ELSE (
				ECHO    ������ ���� �߰ߵǾ� �ʱ�ȭ�� �����Ͽ����� ������ �߻��߽��ϴ�. & >>"!QLog!" ECHO    ������ ���� �߰ߵǾ� �ʱ�ȭ ���� ^(���� - ���� �߻�^)
			)
			ENDLOCAL & GOTO GO_INIT2
		)
	)
	:GO_INIT2
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		ECHO    �������� �߰ߵ��� �ʾҽ��ϴ�. & >>"%QLog%" ECHO    �������� �߰ߵ��� ����
	) ELSE (
		ENDLOCAL
		>VARIABLE\XXXX ECHO 1 & COLOR 4F
	)
	REM :Reset Value
	CALL :RESETVAL

	TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.
)

REM * Delete - Malicious Services
ECHO �� �Ǽ� �� ���� ���� ���� ������ . . . & >>"%QLog%" ECHO    �� �Ǽ� �� ���� ���� ���� ���� :
>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services
SET "STRTMP=HKLM_Services"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\System\CurrentControlSet\Services" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB_EXEC\CHECK\CHK_TRUSTEDSERVICES.DB 2^>Nul') DO (
	TITLE �˻��� "%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%A^|
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\SERVICE\DEL_SERVICE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_SVC NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F "DELIMS=" %%Y IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\%%A\Description" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			>VARIABLE\TXTX ECHO %%Y
			FOR /F %%Z IN ('TOOLS\GREP\GREP.EXE -Fxf DB_EXEC\THREAT\SERVICE\DEL_SERVICE_DESCRIPTION.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_SVC NULL BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F "DELIMS=" %%Y IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\%%A\DisplayName" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			>VARIABLE\TXTX ECHO %%Y
			FOR /F %%Z IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\SERVICE\DEL_SERVICE_DISPLAYNAME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_SVC NULL BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\SERVICE\PATTERN_TYPE1.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_SVC ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\SERVICE\PATTERN_TYPE2.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_SVC ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F "DELIMS=" %%Y IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\%%A\ImagePath" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			>VARIABLE\TXTX ECHO %%Y
			FOR /F %%Z IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\SERVICE\PATTERN_IMAGEPATH.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_SVC ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F "DELIMS=" %%Y IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\%%A\ImagePath" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			>VARIABLE\TXTX ECHO %%Y
			FOR /F %%Z IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\SERVICE\PATTERN_IMAGEPATH_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_SVC ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F "DELIMS=" %%Y IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\%%A\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			>VARIABLE\TXTX ECHO %%Y
			FOR /F %%Z IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\SERVICE\PATTERN_SERVICEDLL.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_SVC ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :Result
CALL :P_RESULT RECK CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Check - Required System Files <#1>
ECHO �� �ʼ� �ý��� ���� Ȯ���� - 1�� . . . & >>"%QLog%" ECHO    �� �ʼ� �ý��� ���� Ȯ�� - 1�� :
FOR /F "TOKENS=1,2,3 DELIMS=|" %%A IN (DB_EXEC\CHECK\CHK_SYSTEMFILE.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ MZK CHECK CHK_SYSTEMFILE.DB ~~~~~~~~~~" (
		IF EXIST "DB_EXEC\MD5CHK\CHK_MD5_%%A.DB" (
			>VARIABLE\TXT2 ECHO %%A
			TITLE Ȯ���� "%%A" 2>Nul
			IF %%B EQU 1 (
				>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%
				CALL :CHK_SYSX
			) ELSE (
				IF %%C EQU 1 (
					IF /I "%ARCHITECTURE%" == "x64" (
						>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64
					) ELSE (
						>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32
					)
					CALL :CHK_SYSX
				) ELSE (
					IF /I "%ARCHITECTURE%" == "x64" (
						>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64
						CALL :CHK_SYSX
					)
					>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32
					CALL :CHK_SYSX
				)
			)
		)
	)
)
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\SRCH SET /P SRCH=
<VARIABLE\FAIL SET /P FAIL=
IF !SRCH! EQU 0 (
	ECHO    �������� �߰ߵ��� �ʾҽ��ϴ�. & >>"%QLog%" ECHO    �������� �߰ߵ��� ����
) ELSE (
	>VARIABLE\XXYY ECHO 1
	IF !FAIL! EQU 1 (
		ECHO. & >>"!QLog!" ECHO.
		ECHO    �� �� ���� ��� Ȯ�� �� ^<3. ���� �ذ�^> ���� ^<���� 13^> �׸� ���� & >>"!QLog!" ECHO    �� ^<3. ���� �ذ�^> ���� ^<���� 13^> �׸� ����
	)
)
ENDLOCAL
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Reset Process Autorun Registry
ECHO �� �ʱ�ȭ ��� ���μ��� �ڵ� ���� ������Ʈ�� Ȯ���� . . . & >>"%QLog%" ECHO    �� �ʱ�ȭ ��� ���μ��� �ڵ� ���� ������Ʈ�� Ȯ�� :
TITLE ^(Ȯ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
REM :HKCU\Software\Microsoft\Windows NT\CurrentVersion\Winlogon (Shell)
TITLE Ȯ���� "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Winlogon : Shell" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%~nxA
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_REG_WINLOGON_SHELL.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
		>VARIABLE\TXT2 ECHO explorer.exe
		CALL :RESETREG Shell NULL BACKUP "HKCU_WinNT_Winlogon"
	)
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon (Shell)
TITLE Ȯ���� "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon : Shell" 2>Nul
>VARIABLE\TXTX TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell" 2>Nul|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /S VARIABLE\TXTX 2^>Nul') DO (
	IF %%~zA LEQ 4 (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
		>VARIABLE\TXT2 ECHO explorer.exe
		CALL :RESETREG Shell NULL NULL NULL
	) ELSE (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_REG_WINLOGON_SHELL.DB VARIABLE\TXTX 2^>Nul') DO (
			>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
			>VARIABLE\TXT2 ECHO explorer.exe
			CALL :RESETREG Shell NULL BACKUP "HKLM_WinNT_Winlogon"
		)
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon (Shell)
IF /I "%ARCHITECTURE%" == "x64" (
	TITLE Ȯ���� "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon : Shell" 2>Nul
	>VARIABLE\TXTX TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell" 2>Nul|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2>Nul
	FOR /F "DELIMS=" %%A IN ('DIR /B /S VARIABLE\TXTX 2^>Nul') DO (
		IF %%~zA LEQ 4 (
			>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon
			>VARIABLE\TXT2 ECHO explorer.exe
			CALL :RESETREG Shell NULL NULL NULL
		) ELSE (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_REG_WINLOGON_SHELL.DB VARIABLE\TXTX 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon
				>VARIABLE\TXT2 ECHO explorer.exe
				CALL :RESETREG Shell NULL BACKUP "HKLM_WinNT_Winlogon(x86)"
			)
		)
	)
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon (System)
TITLE Ȯ���� "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon : System" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\System" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
	>VARIABLE\TXT2 ECHO NULL
	CALL :RESETREG System NULL BACKUP "HKLM_WinNT_Winlogon"
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon (Userinit)
TITLE Ȯ���� "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon : Userinit" 2>Nul
TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Userinit" >Nul 2>Nul
IF %ERRORLEVEL% EQU 1 (
	>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
	>VARIABLE\TXT2 ECHO %MZKSYSTEMROOT%\System32\Userinit.exe,
	CALL :RESETREG Userinit NULL NULL NULL
) ELSE (
	FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Userinit" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
		IF /I NOT "%%~A" == "%SYSTEMROOT%\System32\Userinit.exe," (
			>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
			>VARIABLE\TXT2 ECHO %MZKSYSTEMROOT%\System32\Userinit.exe,
			CALL :RESETREG Userinit NULL BACKUP "HKLM_WinNT_Winlogon"
		)
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon (Userinit)
IF /I "%ARCHITECTURE%" == "x64" (
	TITLE Ȯ���� "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon : Userinit" 2>Nul
	TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon\Userinit" >Nul 2>Nul
	IF %ERRORLEVEL% EQU 1 (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon
		>VARIABLE\TXT2 ECHO %MZKSYSTEMROOT%\System32\Userinit.exe,
		CALL :RESETREG Userinit NULL NULL NULL
	) ELSE (
		FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon\Userinit" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			IF /I NOT "%%~A" == "%SYSTEMROOT%\System32\Userinit.exe," (
				IF /I NOT "%%~A" == "Userinit.exe" (
					>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon
					>VARIABLE\TXT2 ECHO %MZKSYSTEMROOT%\System32\Userinit.exe,
					CALL :RESETREG Userinit NULL BACKUP "HKLM_WinNT_Winlogon(x86)"
				)
			)
		)
	)
)
REG.EXE DELETE "HKLM\System\CurrentControlSet\Control\Session Manager" /v PendingFileRenameOperations /f >Nul 2>Nul
REM :Result
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\SRCH SET /P SRCH=
<VARIABLE\SUCC SET /P SUCC=
<VARIABLE\FAIL SET /P FAIL=
IF !SRCH! EQU 0 (
	ECHO    �������� �߰ߵ��� �ʾҽ��ϴ�. & >>"!QLog!" ECHO    �������� �߰ߵ��� ����
) ELSE (
	ECHO    �߰�: !SRCH! / �ʱ�ȭ: !SUCC! / �ʱ�ȭ ����: !FAIL!
	>VARIABLE\XXYY ECHO 1
)
ENDLOCAL
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Task Killing
ECHO �� �Ǽ� �� ���ʿ��� ���μ��� ������ ^(ȭ���� ��� ������ �� ����^) . . .
FOR /F "DELIMS=" %%A IN (DB_EXEC\CHECK\CHK_PROCESSKILL_FAKESYSTEMPROCESS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ MZK CHECK CHK_PROCESSKILL_FAKESYSTEMPROCESS.DB ~~~~~~~~~~" (
		TITLE Ȯ���� "%%A" 2>Nul
		FOR /F "TOKENS=2 DELIMS=(" %%B IN ('TOOLS\TASKS\TASKKILL.EXE /IM "%%A" 2^>NUL') DO (
			FOR /F "TOKENS=1 DELIMS=)" %%C IN ('ECHO %%B^|TOOLS\GREP\GREP.EXE -Ex "PID [0-9]{1,5}" 2^>Nul') DO (
				TITLE ������ "%%A" 2>Nul
				TOOLS\TASKS\TASKKILL.EXE /F /%%C >Nul 2>Nul
				TOOLS\TASKS\TASKKILL.EXE /F /%%C >Nul 2>Nul
			)
		)
		FOR /F "TOKENS=10,11" %%B IN ('TOOLS\TASKS\TASKKILL.EXE /IM "%%A" 2^>NUL') DO (
			IF /I "%%B" == "PID" (
				TITLE ������ "%%A" 2>Nul
				SET "STRTMP=%%C"
				SETLOCAL ENABLEDELAYEDEXPANSION
				SET "STRTMP=!STRTMP:.=!"
				TOOLS\TASKS\TASKKILL.EXE /F /%%B !STRTMP! >Nul 2>Nul
				TOOLS\TASKS\TASKKILL.EXE /F /%%B !STRTMP! >Nul 2>Nul
				ENDLOCAL
			)
		)
	)
)
FOR /F "DELIMS=" %%A IN (DB_EXEC\CHECK\CHK_PROCESSKILL_BROWSER.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ MZK CHECK CHK_PROCESSKILL_BROWSER.DB ~~~~~~~~~~" (
		TITLE ������ "%%A" 2>Nul
		TOOLS\TASKS\TASKKILL.EXE /F /IM "%%A" >Nul 2>Nul
	)
)
TOOLS\TASKS\TASKKILL.EXE /IM "DOPUS.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /IM "DOPUSRT.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /IM "FLYEXPLORER.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /IM "NEXUSFILE.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /IM "TASKENG.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /IM "TASKHOST.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /IM "WININIT.EXE" >Nul 2>Nul
SC.EXE STOP UXSMS >Nul 2>Nul
FOR /F "TOKENS=1,2,5 DELIMS=," %%A IN ('TOOLS\TASKS\TASKLIST.EXE /FO CSV 2^>Nul^|TOOLS\GREP\GREP.EXE -F "." 2^>Nul') DO (
	SETLOCAL ENABLEDELAYEDEXPANSION
	TOOLS\GREP\GREP.EXE -Fixq "%%~nxA" DB_EXEC\CHECK\CHK_TRUSTEDPROCESS.DB >Nul 2>Nul
	IF !ERRORLEVEL! EQU 1 (
		TITLE ������ "%%~nxA" 2>Nul
		TOOLS\TASKS\TASKKILL.EXE /F /T /IM "%%~nxA" >Nul 2>Nul
	) ELSE (
		TITLE ��ȣ�� "%%~nxA" 2>Nul
	)
	ENDLOCAL
)
SC.EXE START UXSMS >Nul 2>Nul
SCHTASKS.EXE /Run /TN "\Microsoft\Windows\TextServicesFramework\MsCtfMonitor" >Nul 2>Nul
SCHTASKS.EXE /Run /TN "\Microsoft\Windows\Multimedia\SystemSoundsService" >Nul 2>Nul
ECHO    �Ϸ�Ǿ����ϴ�.
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO.

REM * Delete - Temporary & Cache Files #1
ECHO �� �ӽ� ����/���� ������ - 1�� . . .
TITLE ^(������^) ��ø� ��ٷ��ּ��� ^(�ð��� �ټ� �ҿ�� �� ����^) . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\Temp\" 2^>Nul') DO (
	RD /Q /S "%SYSTEMROOT%\Temp\%%A" >Nul 2>Nul
)
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%TEMP%\" 2^>Nul') DO (
	RD /Q /S "%TEMP%\%%A" >Nul 2>Nul
)
DEL /F /Q /S /A "%SYSTEMROOT%\Temp" >Nul 2>Nul
DEL /F /Q /S /A "%APPDATA%\Temp" >Nul 2>Nul
DEL /F /Q /S /A "%TEMP%" >Nul 2>Nul
ECHO    �Ϸ�Ǿ����ϴ�.

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO.

REM * Delete Malicious File
ECHO �� �Ǽ� �� ���� ���� ���� ������ . . .
>>"%QLog%" ECHO    �� �Ǽ� �� ���� ���� ���� ���� :
REM :[%SYSTEMROOT%]\Tasks
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\Tasks\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\Tasks\" 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\Tasks\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\Tasks\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_TASKS_JOB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\Tasks\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_TASKS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\Tasks\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_TASKS.DB VARIABLE\TXT2 2^>Nul') DO (
			IF /I "%%~xA" == ".JOB" (
				>>DB_ACTIVE\ACT_REG_TASKS_JOB.DB ECHO %%A
				>>DB_ACTIVE\ACT_REG_TASKS_JOB.DB ECHO %%A.fp
			)
			CALL :DEL_FILE ACTIVESCAN
		)
	)
	IF EXIST "%SYSTEMROOT%\Tasks\%%A" (
		IF /I "%%~xA" == ".JOB" (
			IF %%~zA LEQ 10000 (
				FOR /F %%X IN ('TOOLS\BINASC\BINASC.EXE -a "%SYSTEMROOT%\Tasks\%%A" --wrap 1500 2^>Nul^|TOOLS\GREP\GREP.EXE -f DB_EXEC\ACTIVESCAN\FILE\PATTERN_TASKS_PATHDATA.DB 2^>Nul') DO (
					>>DB_ACTIVE\ACT_REG_TASKS_JOB.DB ECHO %%A
					>>DB_ACTIVE\ACT_REG_TASKS_JOB.DB ECHO %%A.fp
					CALL :DEL_FILE ACTIVESCAN
				)
			)
		)
	)
)
REM :[%SYSTEMROOT%]\System32\Tasks
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\Tasks\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\System32\Tasks\" 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\System32\Tasks\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\Tasks\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_TASKS_TREE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\System32\Tasks\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_TASKS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\System32\Tasks\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_TASKS.DB VARIABLE\TXT2 2^>Nul') DO (
			>>DB_ACTIVE\ACT_REG_TASKS_TREE.DB ECHO %%A
			CALL :DEL_FILE ACTIVESCAN
		)
	)
	IF EXIST "%SYSTEMROOT%\System32\Tasks\%%A" (
		FOR /F %%X IN ('TYPE "%SYSTEMROOT%\System32\Tasks\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\FILE\PATTERN_TASKS_PATHDATAX.DB 2^>Nul') DO (
			>>DB_ACTIVE\ACT_REG_TASKS_TREE.DB ECHO %%A
			CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :[%SYSTEMROOT%]\SysWOW64\Tasks
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\Tasks\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\Tasks\" 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\SysWOW64\Tasks\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\Tasks\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_TASKS_TREE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Tasks\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_TASKS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Tasks\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_TASKS.DB VARIABLE\TXT2 2^>Nul') DO (
			>>DB_ACTIVE\ACT_REG_TASKS_TREE.DB ECHO %%A
			CALL :DEL_FILE ACTIVESCAN
		)
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Tasks\%%A" (
		FOR /F %%X IN ('TYPE "%SYSTEMROOT%\SysWOW64\Tasks\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\FILE\PATTERN_TASKS_PATHDATAX.DB 2^>Nul') DO (
			>>DB_ACTIVE\ACT_REG_TASKS_TREE.DB ECHO %%A
			CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :[%SYSTEMDRIVE%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %SYSTEMDRIVE%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMDRIVE%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_ROOT.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMDRIVE%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMDRIVE%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_ROOT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMDRIVE%\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%SYSTEMDRIVE%\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
	IF EXIST "%SYSTEMDRIVE%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_ROOT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%SYSTEMDRIVE%] (for 1-Step MD5)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMDRIVE%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_ROOT.DB 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %SYSTEMDRIVE%\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMDRIVE%\%%A\" 2^>Nul') DO (
		TITLE �˻��� "%SYSTEMDRIVE%\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%SYSTEMDRIVE%\%%A\%%B" (
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%SYSTEMDRIVE%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
			)
		)
	)
)
REM :[%SYSTEMDRIVE%] (ETCs)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\FILEDEL_ROOT_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		TITLE �˻���^(DB^) "%SYSTEMDRIVE%%%A" 2>Nul
		IF EXIST "%SYSTEMDRIVE%%%A" (
			>VARIABLE\TXT1 ECHO %SYSTEMDRIVE%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
	)
)
REM :[%SYSTEMROOT%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_SYSTEMROOT.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_SYSTEMROOT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%SYSTEMROOT%\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
	IF EXIST "%SYSTEMROOT%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEMROOT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%]\System
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\System\" 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\System\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_SYSTEM.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
)
REM :[%SYSTEMROOT%]\System32
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\System32\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_SYSTEM6432.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\System32\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_SYSTEM6432.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\System32\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%SYSTEMROOT%\System32\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
	IF EXIST "%SYSTEMROOT%\System32\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEM6432.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%]\SysWOW64
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_SYSTEM6432.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\SysWOW64\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_SYSTEM6432.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%SYSTEMROOT%\SysWOW64\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEM6432.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%]\System32\Drivers
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\Drivers\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\System32\Drivers\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_SYSTEM6432_DRIVERS.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\System32\Drivers\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\Drivers\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_ROOTKIT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\System32\Drivers\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_SYSTEM6432_DRIVERS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\System32\Drivers\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_ROOTKIT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%]\SysWOW64\Drivers
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\Drivers\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\Drivers\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_SYSTEM6432_DRIVERS.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\SysWOW64\Drivers\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\Drivers\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_ROOTKIT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Drivers\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_SYSTEM6432_DRIVERS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Drivers\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_ROOTKIT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%]\System32/SysWOW64 (ETCs)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\FILEDEL_SYSTEM6432_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		TITLE �˻���^(DB^) "%SYSTEMROOT%\System32%%A" 2>Nul
		IF EXIST "%SYSTEMROOT%\System32%%A" (
			>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
		TITLE �˻���^(DB^) "%SYSTEMROOT%\SysWOW64%%A" 2>Nul
		IF EXIST "%SYSTEMROOT%\SysWOW64%%A" (
			>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
	)
)
REM :[%SYSTEMROOT%] (ETCs)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\FILEDEL_SYSTEMROOT_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		TITLE �˻���^(DB^) "%SYSTEMROOT%%%A" 2>Nul
		IF EXIST "%SYSTEMROOT%%%A" (
			>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
	)
)
REM :[%ALLUSERSPROFILE%]\Microsoft\Windows\Start Menu\Programs\StartUp
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\StartUp\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\StartUp\" 2^>Nul') DO (
	TITLE �˻��� "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_STARTUP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_STARTUP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
	IF /I "%%~xA" == ".LNK" (
		IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" (
			FOR /F "TOKENS=1,* DELIMS==" %%B IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "WorkingDirectory=" 2^>Nul') DO (
				>VARIABLE\TXTX ECHO %%C
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_STARTUP_PATHDATA.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
			)
		)
	)
	IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
)
REM :[%APPDATA%]\Microsoft\Windows\Start Menu\Programs\StartUp
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%APPDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\" 2^>Nul') DO (
	TITLE �˻��� "%APPDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%APPDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_STARTUP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%APPDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_STARTUP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
	IF /I "%%~xA" == ".LNK" (
		IF EXIST "%APPDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" (
			FOR /F "TOKENS=1,* DELIMS==" %%B IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%APPDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "WorkingDirectory=" 2^>Nul') DO (
				>VARIABLE\TXTX ECHO %%C
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_STARTUP_PATHDATA.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
			)
		)
	)
	IF EXIST "%APPDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
)
REM :[%ALLUSERSPROFILE%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_APPDATA.DB 2^>Nul^|TOOLS\GREP\GREP.EXE -ixvf DB\EXCEPT\EX_FILE_APPDATA_REGEX.DB 2^>Nul') DO (
	TITLE �˻��� "%ALLUSERSPROFILE%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%ALLUSERSPROFILE%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_PROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%ALLUSERSPROFILE%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%ALLUSERSPROFILE%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%ALLUSERSPROFILE%] (for 1-Step & MD5)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%ALLUSERSPROFILE%\" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%ALLUSERSPROFILE%\%%A\" 2^>Nul') DO (
		TITLE �˻��� "%ALLUSERSPROFILE%\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%ALLUSERSPROFILE%\%%A\%%B" (
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%ALLUSERSPROFILE%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
			)
		)
	)
)
REM :[%ALLUSERSPROFILE%]\Application Data
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Application Data\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\Application Data\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_APPDATA.DB 2^>Nul^|TOOLS\GREP\GREP.EXE -ixvf DB\EXCEPT\EX_FILE_APPDATA_REGEX.DB 2^>Nul') DO (
	TITLE �˻��� "%ALLUSERSPROFILE%\Application Data\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%ALLUSERSPROFILE%\Application Data\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_PROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%ALLUSERSPROFILE%\Application Data\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%ALLUSERSPROFILE%\Application Data\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%LOCALAPPDATA%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%LOCALAPPDATA%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_APPDATA.DB 2^>Nul') DO (
	TITLE �˻��� "%LOCALAPPDATA%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%LOCALAPPDATA%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%LOCALAPPDATA%] (for 1-Step & MD5)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%LOCALAPPDATA%\%%A\" 2^>Nul') DO (
		TITLE �˻��� "%LOCALAPPDATA%\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%LOCALAPPDATA%\%%A\%%B" (
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%LOCALAPPDATA%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
			)
		)
	)
)
REM :[%LOCALLOWAPPDATA%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALLOWAPPDATA%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%LOCALLOWAPPDATA%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_APPDATA.DB 2^>Nul') DO (
	TITLE �˻��� "%LOCALLOWAPPDATA%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALLOWAPPDATA%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%LOCALLOWAPPDATA%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%LOCALLOWAPPDATA%] (for 1-Step & MD5)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALLOWAPPDATA%\" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKLOCALLOWAPPDATA%\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%LOCALLOWAPPDATA%\%%A\" 2^>Nul') DO (
		TITLE �˻��� "%LOCALLOWAPPDATA%\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%LOCALLOWAPPDATA%\%%A\%%B" (
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%LOCALLOWAPPDATA%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
			)
		)
	)
)
REM :[%APPDATA%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%APPDATA%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_APPDATA.DB 2^>Nul') DO (
	TITLE �˻��� "%APPDATA%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%APPDATA%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%APPDATA%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%APPDATA%] (for 1-Step & MD5)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%APPDATA%\" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKAPPDATA%\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%APPDATA%\%%A\" 2^>Nul') DO (
		TITLE �˻��� "%APPDATA%\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%APPDATA%\%%A\%%B" (
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%APPDATA%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
			)
		)
	)
)
REM :[%SYSTEMROOT%]\System32\Config\SystemProfile\AppData\Local
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_APPDATA.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%]\SysWOW64\Config\SystemProfile\AppData\Local
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_APPDATA.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%]\System32\Config\SystemProfile\AppData\LocalLow
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_APPDATA.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%]\SysWOW64\Config\SystemProfile\AppData\LocalLow
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_APPDATA.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%]\System32\Config\SystemProfile\AppData\Roaming
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_APPDATA.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%]\SysWOW64\Config\SystemProfile\AppData\Roaming
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_APPDATA.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :Application Data (ETCs)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\FILEDEL_APPDATA_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		TITLE �˻���^(DB^) "%ALLUSERSPROFILE%%%A" 2>Nul
		IF EXIST "%ALLUSERSPROFILE%%%A" (
			>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
		TITLE �˻���^(DB^) "%ALLUSERSPROFILE%\Application Data%%A" 2>Nul
		IF EXIST "%ALLUSERSPROFILE%\Application Data%%A" (
			>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Application Data%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
		TITLE �˻���^(DB^) "%LOCALAPPDATA%%%A" 2>Nul
		IF EXIST "%LOCALAPPDATA%%%A" (
			>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
		TITLE �˻���^(DB^) "%LOCALLOWAPPDATA%%%A" 2>Nul
		IF EXIST "%LOCALLOWAPPDATA%%%A" (
			>VARIABLE\TXT1 ECHO %MZKLOCALLOWAPPDATA%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
		TITLE �˻���^(DB^) "%APPDATA%%%A" 2>Nul
		IF EXIST "%APPDATA%%%A" (
			>VARIABLE\TXT1 ECHO %MZKAPPDATA%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
	)
)
REM :[%ALLUSERSPROFILE%]\Desktop
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Desktop\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\Desktop\" 2^>Nul') DO (
	TITLE �˻��� "%ALLUSERSPROFILE%\Desktop\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%ALLUSERSPROFILE%\Desktop\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_DESKTOP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%ALLUSERSPROFILE%\Desktop\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%ALLUSERSPROFILE%\Desktop\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
)
REM :[%USERPROFILE%]\Desktop
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKUSERPROFILE%\Desktop\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%USERPROFILE%\Desktop\" 2^>Nul') DO (
	TITLE �˻��� "%USERPROFILE%\Desktop\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%USERPROFILE%\Desktop\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_DESKTOP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%USERPROFILE%\Desktop\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%USERPROFILE%\Desktop\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
)
REM :[%SYSTEMROOT%]\System32\Config\SystemProfile\Desktop
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\Config\SystemProfile\Desktop\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\System32\Config\SystemProfile\Desktop\" 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\System32\Config\SystemProfile\Desktop\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\Desktop\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_DESKTOP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\Desktop\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%SYSTEMROOT%\System32\Config\SystemProfile\Desktop\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
)
REM :[%SYSTEMROOT%]\SysWOW64\Config\SystemProfile\Desktop
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\Config\SystemProfile\Desktop\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\Desktop\" 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\Desktop\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\Desktop\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_DESKTOP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\Desktop\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\Desktop\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
)
REM :[%PUBLIC%]\Desktop
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKPUBLIC%\Desktop\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%PUBLIC%\Desktop\" 2^>Nul') DO (
	TITLE �˻��� "%PUBLIC%\Desktop\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%PUBLIC%\Desktop\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_DESKTOP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%PUBLIC%\Desktop\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%PUBLIC%\Desktop\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
)
REM :[%USERPROFILE%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKUSERPROFILE%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%USERPROFILE%\" 2^>Nul') DO (
	TITLE �˻��� "%USERPROFILE%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%USERPROFILE%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_PROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%USERPROFILE%\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%USERPROFILE%\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
	IF EXIST "%USERPROFILE%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_PROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%USERPROFILE%]\Documents
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKUSERPROFILE%\Documents\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%USERPROFILE%\Documents\" 2^>Nul') DO (
	TITLE �˻��� "%USERPROFILE%\Documents\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%USERPROFILE%\Documents\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_PROFILE_DOCUMENTS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%USERPROFILE%\Documents\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%USERPROFILE%\Documents\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
)
REM :[%PUBLIC%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKPUBLIC%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%PUBLIC%\" 2^>Nul') DO (
	TITLE �˻��� "%PUBLIC%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%PUBLIC%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_PROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
)
REM :Profiles (ETCs)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\FILEDEL_PROFILE_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		TITLE �˻���^(DB^) "%ALLUSERSPROFILE%%%A" 2>Nul
		IF EXIST "%ALLUSERSPROFILE%%%A" (
			>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
		TITLE �˻���^(DB^) "%USERPROFILE%%%A" 2>Nul
		IF EXIST "%USERPROFILE%%%A" (
			>VARIABLE\TXT1 ECHO %MZKUSERPROFILE%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
		TITLE �˻���^(DB^) "%PUBLIC%%%A" 2>Nul
		IF EXIST "%PUBLIC%%%A" (
			>VARIABLE\TXT1 ECHO %MZKPUBLIC%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
	)
)
REM :[%ALLUSERSPROFILE%]\Templates
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Templates\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\Templates\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_TEMPLATES.DB 2^>Nul') DO (
	TITLE �˻��� "%ALLUSERSPROFILE%\Templates\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%ALLUSERSPROFILE%\Templates\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_TEMPLATES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%ALLUSERSPROFILE%]\Microsoft\Windows\Templates
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Microsoft\Windows\Templates\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\Microsoft\Windows\Templates\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_TEMPLATES.DB 2^>Nul') DO (
	TITLE �˻��� "%ALLUSERSPROFILE%\Microsoft\Windows\Templates\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Templates\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_TEMPLATES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%USERPROFILE%]\Templates
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKUSERPROFILE%\Templates\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%USERPROFILE%\Templates\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_TEMPLATES.DB 2^>Nul') DO (
	TITLE �˻��� "%USERPROFILE%\Templates\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%USERPROFILE%\Templates\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_TEMPLATES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%APPDATA%]\Microsoft\Windows\Templates
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Microsoft\Windows\Templates\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%APPDATA%\Microsoft\Windows\Templates\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_TEMPLATES.DB 2^>Nul') DO (
	TITLE �˻��� "%APPDATA%\Microsoft\Windows\Templates\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%APPDATA%\Microsoft\Windows\Templates\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_TEMPLATES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%PROGRAMFILES%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKPROGRAMFILES%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%PROGRAMFILES%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_PROGRAMFILES.DB 2^>Nul') DO (
	TITLE �˻��� "%PROGRAMFILES%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%PROGRAMFILES%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_PROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%PROGRAMFILES%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_PROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
	IF EXIST "%PROGRAMFILES%\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%PROGRAMFILES%\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
)
REM :[%PROGRAMFILESX86%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKPROGRAMFILESX86%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%PROGRAMFILESX86%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_PROGRAMFILES.DB 2^>Nul') DO (
	TITLE �˻��� "%PROGRAMFILESX86%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%PROGRAMFILESX86%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_PROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%PROGRAMFILESX86%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_PROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
	IF EXIST "%PROGRAMFILESX86%\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%PROGRAMFILESX86%\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
)
REM :[%PROGRAMFILES%] (for 1-Step & MD5)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%PROGRAMFILES%\" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKPROGRAMFILES%\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%PROGRAMFILES%\%%A\" 2^>Nul') DO (
		TITLE �˻��� "%PROGRAMFILES%\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%PROGRAMFILES%\%%A\%%B" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_PROGRAMFILES_1STEP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%PROGRAMFILES%\%%A\%%B" (
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%PROGRAMFILES%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
			)
		)
	)
)
REM :[%PROGRAMFILESX86%] (for 1-Step & MD5)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%PROGRAMFILESX86%\" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKPROGRAMFILESX86%\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%PROGRAMFILESX86%\%%A\" 2^>Nul') DO (
		TITLE �˻��� "%PROGRAMFILESX86%\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%PROGRAMFILESX86%\%%A\%%B" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_PROGRAMFILES_1STEP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%PROGRAMFILESX86%\%%A\%%B" (
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%PROGRAMFILESX86%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
			)
		)
	)
)
REM :[%COMMONPROGRAMFILES%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILES%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%COMMONPROGRAMFILES%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_COMMONPROGRAMFILES.DB 2^>Nul') DO (
	TITLE �˻��� "%COMMONPROGRAMFILES%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%COMMONPROGRAMFILES%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_COMMONPROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%COMMONPROGRAMFILESX86%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILESX86%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%COMMONPROGRAMFILESX86%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_COMMONPROGRAMFILES.DB 2^>Nul') DO (
	TITLE �˻��� "%COMMONPROGRAMFILESX86%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%COMMONPROGRAMFILESX86%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_COMMONPROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%COMMONPROGRAMFILES%]\Services
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILES%\Services\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%COMMONPROGRAMFILES%\Services\" 2^>Nul') DO (
	TITLE �˻��� "%COMMONPROGRAMFILES%\Services\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%COMMONPROGRAMFILES%\Services\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_COMMONPROGRAMFILES_SERVICES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%COMMONPROGRAMFILES%\Services\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_COMMONPROGRAMFILES_SERVICES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%COMMONPROGRAMFILESX86%]\Services
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILESX86%\Services\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%COMMONPROGRAMFILESX86%\Services\" 2^>Nul') DO (
	TITLE �˻��� "%COMMONPROGRAMFILESX86%\Services\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%COMMONPROGRAMFILESX86%\Services\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_COMMONPROGRAMFILES_SERVICES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%COMMONPROGRAMFILESX86%\Services\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_COMMONPROGRAMFILES_SERVICES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%COMMONPROGRAMFILES%]\System
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILES%\System\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%COMMONPROGRAMFILES%\System\" 2^>Nul') DO (
	TITLE �˻��� "%COMMONPROGRAMFILES%\System\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%COMMONPROGRAMFILES%\System\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_COMMONPROGRAMFILES_SYSTEM.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%COMMONPROGRAMFILES%\System\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_COMMONPROGRAMFILES_SYSTEM.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%COMMONPROGRAMFILESX86%]\System
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILESX86%\System\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%COMMONPROGRAMFILESX86%\System\" 2^>Nul') DO (
	TITLE �˻��� "%COMMONPROGRAMFILESX86%\System\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%COMMONPROGRAMFILESX86%\System\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_COMMONPROGRAMFILES_SYSTEM.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%COMMONPROGRAMFILESX86%\System\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_COMMONPROGRAMFILES_SYSTEM.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%PROGRAMFILES%] (ETCs)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\FILEDEL_PROGRAMFILES_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		TITLE �˻���^(DB^) "%PROGRAMFILES%%%A" 2>Nul
		IF EXIST "%PROGRAMFILES%%%A" (
			>VARIABLE\TXT1 ECHO %MZKPROGRAMFILES%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
		TITLE �˻���^(DB^) "%PROGRAMFILESX86%%%A" 2>Nul
		IF EXIST "%PROGRAMFILESX86%%%A" (
			>VARIABLE\TXT1 ECHO %MZKPROGRAMFILESX86%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
	)
)
REM :(Active Scan) [%SYSTEMROOT%] (Hidden)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AH-D "%SYSTEMROOT%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_SYSTEMROOT.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEMROOT_ONLYHIDDEN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%] (Super Hidden)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AHS-D "%SYSTEMROOT%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_SYSTEMROOT.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEMROOT_ONLYSUPERHIDDEN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\addins
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\addins\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\addins\" 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\addins\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\addins\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEMROOT_ADDINS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\AppPatch
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\AppPatch\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\AppPatch\" 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\AppPatch\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\AppPatch\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEMROOT_APPPATCH.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\Fonts
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\Fonts\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\Fonts\" 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\Fonts\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\Fonts\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_FONTS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\Installer
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\Installer\" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\Installer\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMROOT%\Installer\%%A\" 2^>Nul') DO (
		TITLE �˻��� "%SYSTEMROOT%\Installer\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%SYSTEMROOT%\Installer\%%A\%%B" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEMROOT_INSTALLER_1STEP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\System (Super Hidden)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System\
FOR /F "DELIMS=" %%A IN ('DIR /B /AHS-D "%SYSTEMROOT%\System\" 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\System\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEM_ONLYSUPERHIDDEN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\System32 (4 Digit Directory)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\System32\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Eix "[0-9]{4}" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMROOT%\System32\%%A\" 2^>Nul') DO (
		TITLE �˻��� "%SYSTEMROOT%\System32\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%SYSTEMROOT%\System32\%%A\%%B" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEM6432_4DIGITS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\SysWOW64 (4 Digit Directory)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\SysWOW64\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Eix "[0-9]{4}" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\%%A\" 2^>Nul') DO (
		TITLE �˻��� "%SYSTEMROOT%\SysWOW64\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%SYSTEMROOT%\SysWOW64\%%A\%%B" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEM6432_4DIGITS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\System32 (12 Char Directory)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\System32\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Eix "[0-9A-Z]{12}" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMROOT%\System32\%%A\" 2^>Nul') DO (
		TITLE �˻��� "%SYSTEMROOT%\System32\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%SYSTEMROOT%\System32\%%A\%%B" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEM6432_12DIGITS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\SysWOW64 (12 Char Directory)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\SysWOW64\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Eix "[0-9A-Z]{12}" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\%%A\" 2^>Nul') DO (
		TITLE �˻��� "%SYSTEMROOT%\SysWOW64\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%SYSTEMROOT%\SysWOW64\%%A\%%B" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEM6432_12DIGITS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\System32 (Hidden)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\
FOR /F "DELIMS=" %%A IN ('DIR /B /AH-D "%SYSTEMROOT%\System32\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_SYSTEM6432.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\System32\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEM6432_ONLYHIDDEN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\SysWOW64 (Hidden)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\
FOR /F "DELIMS=" %%A IN ('DIR /B /AH-D "%SYSTEMROOT%\SysWOW64\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_SYSTEM6432.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\SysWOW64\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEM6432_ONLYHIDDEN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\System32 (Super Hidden)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\
FOR /F "DELIMS=" %%A IN ('DIR /B /AHS-D "%SYSTEMROOT%\System32\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_SYSTEM6432.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\System32\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEM6432_ONLYSUPERHIDDEN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\SysWOW64 (Super Hidden)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\
FOR /F "DELIMS=" %%A IN ('DIR /B /AHS-D "%SYSTEMROOT%\SysWOW64\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_SYSTEM6432.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\SysWOW64\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEM6432_ONLYSUPERHIDDEN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) [%ALLUSERSPROFILE%]\Java (Target)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Java\
IF EXIST "%ALLUSERSPROFILE%\Java\" ATTRIB.EXE -H -S "%ALLUSERSPROFILE%\Java" /S /D >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\Java\" 2^>Nul') DO (
	TITLE �˻��� "%ALLUSERSPROFILE%\Java\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%ALLUSERSPROFILE%\Java\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_TARGET_JAVA.DB VARIABLE\TXT2 2^>Nul') DO (
			TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "%ALLUSERSPROFILE%\Java" -ot file -actn setowner -ownr "n:Administrators" -silent >Nul 2>Nul
			TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "%ALLUSERSPROFILE%\Java" -ot file -actn clear -clr "dacl,sacl" -actn setprot -op "dacl:np;sacl:np" -silent >Nul 2>Nul
			CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :(Active Scan) [%ALLUSERSPROFILE%]\Application Data\Java (Target)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Application Data\Java\
IF EXIST "%ALLUSERSPROFILE%\Application Data\Java\" ATTRIB.EXE -H -S "%ALLUSERSPROFILE%\Application Data\Java" /S /D >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\Application Data\Java\" 2^>Nul') DO (
	TITLE �˻��� "%ALLUSERSPROFILE%\Application Data\Java\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%ALLUSERSPROFILE%\Application Data\Java\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_TARGET_JAVA.DB VARIABLE\TXT2 2^>Nul') DO (
			TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "%ALLUSERSPROFILE%\Application Data\Java" -ot file -actn setowner -ownr "n:Administrators" -silent >Nul 2>Nul
			TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "%ALLUSERSPROFILE%\Application Data\Java" -ot file -actn clear -clr "dacl,sacl" -actn setprot -op "dacl:np;sacl:np" -silent >Nul 2>Nul
			CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :(Active Scan) [%COMMONPROGRAMFILES%]\Java (Target)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILES%\Java\
IF EXIST "%COMMONPROGRAMFILES%\Java\" ATTRIB.EXE -H -S "%COMMONPROGRAMFILES%\Java" /S /D >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%COMMONPROGRAMFILES%\Java\" 2^>Nul') DO (
	TITLE �˻��� "%COMMONPROGRAMFILES%\Java\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%COMMONPROGRAMFILES%\Java\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_TARGET_JAVA.DB VARIABLE\TXT2 2^>Nul') DO (
			TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "%COMMONPROGRAMFILES%\Java" -ot file -actn setowner -ownr "n:Administrators" -silent >Nul 2>Nul
			TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "%COMMONPROGRAMFILES%\Java" -ot file -actn clear -clr "dacl,sacl" -actn setprot -op "dacl:np;sacl:np" -silent >Nul 2>Nul
			CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :(Active Scan) [%COMMONPROGRAMFILESX86%]\Java (Target)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILESX86%\Java\
IF EXIST "%COMMONPROGRAMFILESX86%\Java\" ATTRIB.EXE -H -S "%COMMONPROGRAMFILESX86%\Java" /S /D >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%COMMONPROGRAMFILESX86%\Java\" 2^>Nul') DO (
	TITLE �˻��� "%COMMONPROGRAMFILESX86%\Java\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%COMMONPROGRAMFILESX86%\Java\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_TARGET_JAVA.DB VARIABLE\TXT2 2^>Nul') DO (
			TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "%COMMONPROGRAMFILESX86%\Java" -ot file -actn setowner -ownr "n:Administrators" -silent >Nul 2>Nul
			TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "%COMMONPROGRAMFILESX86%\Java" -ot file -actn clear -clr "dacl,sacl" -actn setprot -op "dacl:np;sacl:np" -silent >Nul 2>Nul
			CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :(Active Scan) [%APPDATA%]\Identities
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Identities\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%APPDATA%\Identities\" 2^>Nul') DO (
	TITLE �˻��� "%APPDATA%\Identities\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%APPDATA%\Identities\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA_IDENTITIES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) [%USERPROFILE%] (Hidden)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKUSERPROFILE%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AH-D "%USERPROFILE%\" 2^>Nul') DO (
	TITLE �˻��� "%USERPROFILE%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%USERPROFILE%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_PROFILE_ONLYHIDDEN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) C:\Program Files (x64)\Microsoft.NET
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %SYSTEMDRIVE%\Program Files ^(x64^)\Microsoft.NET\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMDRIVE%\Program Files (x64)\Microsoft.NET\" 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMDRIVE%\Program Files (x64)\Microsoft.NET\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMDRIVE%\Program Files (x64)\Microsoft.NET\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_PROGRAMFILES_X64_MSDOTNET.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) Browser Extensions - Chrome Plus (Searching Only)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Extensions\" 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('DIR /B /AD "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Extensions\%%A\" 2^>Nul') DO (
		TITLE �˻��� "%LOCALAPPDATA%\MapleStudio\ChromePlus\��������\Extensions\%%A" 2>Nul
		FOR /F "DELIMS=" %%C IN ('DIR /B /A-D "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Extensions\%%A\%%B\" 2^>Nul') DO (
			IF /I "%%C" == "BACKGROUND.HTML" (
				FOR /F %%X IN ('TYPE "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Extensions\%%A\%%B\%%C" 2^>Nul^|TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_BROWSER_EXTENSIONS_CHROME_BACKGROUND.DB 2^>Nul') DO >>DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB ECHO %%A
			)
		)
	)
)
REM :(Active Scan) Browser Extensions - Chromium (Searching Only)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Chromium\User Data\Default\Extensions\" 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('DIR /B /AD "%LOCALAPPDATA%\Chromium\User Data\Default\Extensions\%%A\" 2^>Nul') DO (
		TITLE �˻��� "%LOCALAPPDATA%\Chromium\��������\Extensions\%%A" 2>Nul
		FOR /F "DELIMS=" %%C IN ('DIR /B /A-D "%LOCALAPPDATA%\Chromium\User Data\Default\Extensions\%%A\%%B\" 2^>Nul') DO (
			IF /I "%%C" == "BACKGROUND.HTML" (
				FOR /F %%X IN ('TYPE "%LOCALAPPDATA%\Chromium\User Data\Default\Extensions\%%A\%%B\%%C" 2^>Nul^|TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_BROWSER_EXTENSIONS_CHROME_BACKGROUND.DB 2^>Nul') DO >>DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB ECHO %%A
			)
		)
	)
)
REM :(Active Scan) Browser Extensions - COMODO Dragon (Searching Only)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Extensions\" 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('DIR /B /AD "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Extensions\%%A\" 2^>Nul') DO (
		TITLE �˻��� "%LOCALAPPDATA%\COMODO\Dragon\��������\Extensions\%%A" 2>Nul
		FOR /F "DELIMS=" %%C IN ('DIR /B /A-D "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Extensions\%%A\%%B\" 2^>Nul') DO (
			IF /I "%%C" == "BACKGROUND.HTML" (
				FOR /F %%X IN ('TYPE "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Extensions\%%A\%%B\%%C" 2^>Nul^|TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_BROWSER_EXTENSIONS_CHROME_BACKGROUND.DB 2^>Nul') DO >>DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB ECHO %%A
			)
		)
	)
)
REM :(Active Scan) Browser Extensions - Google Chrome (Searching Only)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Extensions\" 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('DIR /B /AD "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Extensions\%%A\" 2^>Nul') DO (
		TITLE �˻��� "%LOCALAPPDATA%\Google\Chrome\��������\Extensions\%%A" 2>Nul
		FOR /F "DELIMS=" %%C IN ('DIR /B /A-D "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Extensions\%%A\%%B\" 2^>Nul') DO (
			IF /I "%%C" == "BACKGROUND.HTML" (
				FOR /F %%X IN ('TYPE "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Extensions\%%A\%%B\%%C" 2^>Nul^|TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_BROWSER_EXTENSIONS_CHROME_BACKGROUND.DB 2^>Nul') DO >>DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB ECHO %%A
			)
		)
	)
)
REM :(Active Scan) Browser Extensions - Google Chrome SxS (Searching Only)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Extensions\" 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('DIR /B /AD "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Extensions\%%A\" 2^>Nul') DO (
		TITLE �˻��� "%LOCALAPPDATA%\Google\Chrome SxS\��������\Extensions\%%A" 2>Nul
		FOR /F "DELIMS=" %%C IN ('DIR /B /A-D "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Extensions\%%A\%%B\" 2^>Nul') DO (
			IF /I "%%C" == "BACKGROUND.HTML" (
				FOR /F %%X IN ('TYPE "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Extensions\%%A\%%B\%%C" 2^>Nul^|TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_BROWSER_EXTENSIONS_CHROME_BACKGROUND.DB 2^>Nul') DO >>DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB ECHO %%A
			)
		)
	)
)
REM :(Active Scan) Browser Extensions - Opera (Searching Only)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%APPDATA%\Opera Software\Opera Stable\Extensions\" 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('DIR /B /AD "%APPDATA%\Opera Software\Opera Stable\Extensions\%%A\" 2^>Nul') DO (
		TITLE �˻��� "%APPDATA%\Opera Software\Opera Stable\Extensions\%%A" 2>Nul
		FOR /F "DELIMS=" %%C IN ('DIR /B /A-D "%APPDATA%\Opera Software\Opera Stable\Extensions\%%A\%%B\" 2^>Nul') DO (
			IF /I "%%C" == "BACKGROUND.HTML" (
				FOR /F %%X IN ('TYPE "%APPDATA%\Opera Software\Opera Stable\Extensions\%%A\%%B\%%C" 2^>Nul^|TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_BROWSER_EXTENSIONS_CHROME_BACKGROUND.DB 2^>Nul') DO >>DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB ECHO %%A
			)
		)
	)
)
REM :Browser Extensions - Chrome Plus
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Local Storage\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Local Storage\" 2^>Nul') DO (
	TITLE �˻��� "%LOCALAPPDATA%\MapleStudio\ChromePlus\��������\Local Storage\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "TOKENS=2 DELIMS=_" %%B IN (VARIABLE\TXT2) DO (
		>VARIABLE\TXTX ECHO %%B
		IF EXIST "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :Browser Extensions - Chromium
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Chromium\User Data\Default\Local Storage\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%LOCALAPPDATA%\Chromium\User Data\Default\Local Storage\" 2^>Nul') DO (
	TITLE �˻��� "%LOCALAPPDATA%\Chromium\��������\Local Storage\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "TOKENS=2 DELIMS=_" %%B IN (VARIABLE\TXT2) DO (
		>VARIABLE\TXTX ECHO %%B
		IF EXIST "%LOCALAPPDATA%\Chromium\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_BROWSER_EXTENSIONS_CHROME_LOCALSTORAGE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%LOCALAPPDATA%\Chromium\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%LOCALAPPDATA%\Chromium\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :Browser Extensions - COMODO Dragon
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\COMODO\Dragon\User Data\Default\Local Storage\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Local Storage\" 2^>Nul') DO (
	TITLE �˻��� "%LOCALAPPDATA%\COMODO\Dragon\��������\Local Storage\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "TOKENS=2 DELIMS=_" %%B IN (VARIABLE\TXT2) DO (
		>VARIABLE\TXTX ECHO %%B
		IF EXIST "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_BROWSER_EXTENSIONS_CHROME_LOCALSTORAGE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :Browser Extensions - Google Chrome
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Google\Chrome\User Data\Default\Local Storage\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Local Storage\" 2^>Nul') DO (
	TITLE �˻��� "%LOCALAPPDATA%\Google\Chrome\��������\Local Storage\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "TOKENS=2 DELIMS=_" %%B IN (VARIABLE\TXT2) DO (
		>VARIABLE\TXTX ECHO %%B
		IF EXIST "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_BROWSER_EXTENSIONS_CHROME_LOCALSTORAGE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :Browser Extensions - Google Chrome SxS
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Local Storage\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Local Storage\" 2^>Nul') DO (
	TITLE �˻��� "%LOCALAPPDATA%\Google\Chrome SxS\��������\Local Storage\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "TOKENS=2 DELIMS=_" %%B IN (VARIABLE\TXT2) DO (
		>VARIABLE\TXTX ECHO %%B
		IF EXIST "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_BROWSER_EXTENSIONS_CHROME_LOCALSTORAGE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :Browser Extensions - Opera
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Opera Software\Opera Stable\Local Storage\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%APPDATA%\Opera Software\Opera Stable\Local Storage\" 2^>Nul') DO (
	TITLE �˻��� "%APPDATA%\Opera Software\Opera Stable\Local Storage\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "TOKENS=2 DELIMS=_" %%B IN (VARIABLE\TXT2) DO (
		>VARIABLE\TXTX ECHO %%B
		IF EXIST "%APPDATA%\Opera Software\Opera Stable\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_BROWSER_EXTENSIONS_CHROME_LOCALSTORAGE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%APPDATA%\Opera Software\Opera Stable\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%APPDATA%\Opera Software\Opera Stable\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :Browser Extensions - Mozilla Firefox
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%APPDATA%\Mozilla\Firefox\Profiles\" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Mozilla\Firefox\Profiles\%%A\Extensions\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%APPDATA%\Mozilla\Firefox\Profiles\%%A\Extensions\" 2^>Nul') DO (
		TITLE �˻��� "%APPDATA%\Mozilla\Firefox\��������\%%A\Extensions\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%APPDATA%\Mozilla\Firefox\Profiles\%%A\Extensions\%%B" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_BROWSER_EXTENSIONS_FIREFOX.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
		)
	)
)
REM :D: Root (MD5)
IF /I "%DDRV%" == "TRUE" (
	IF /I NOT "%SYSTEMDRIVE%" == "D:" (
		TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
		FOR /F "DELIMS=" %%A IN ('DIR /B /AD "D:\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_ROOT.DB 2^>Nul') DO (
			>VARIABLE\TXT1 ECHO D:\%%A\
			FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "D:\%%A\" 2^>Nul') DO (
				TITLE �˻��� "D:\%%A\%%B" 2>Nul
				>VARIABLE\TXT2 ECHO %%B
				IF EXIST "D:\%%A\%%B" (
					FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "D:\%%A\%%B" 2^>Nul') DO (
						FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
					)
				)
			)
		)
	)
)
REM :Static
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\THREAT\FILE\DEL_STATIC.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ MZK THREAT FILE DEL_STATIC.DB ~~~~~~~~~~" (
		TITLE �˻���^(DB^) "%%A" 2>Nul
		IF EXIST "%%A\" (
			>VARIABLE\TXT1 ECHO %%~dpA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
	)
)
REM :Result
CALL :P_RESULT RECK CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Delete - Malicious Directory
ECHO �� �Ǽ� �� ���� ���� ���� ������ . . . & >>"%QLog%" ECHO    �� �Ǽ� �� ���� ���� ���� ���� :
REM :[%SYSTEMDRIVE%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %SYSTEMDRIVE%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMDRIVE%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_ROOT.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMDRIVE%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMDRIVE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_ROOT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%SYSTEMDRIVE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_ROOT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMDRIVE%\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMDRIVE%\%%A\" 2^>Nul') DO (
			TITLE �˻��� "%SYSTEMDRIVE%\%%A" "%%B" 2>Nul
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%SYSTEMDRIVE%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_ROOT_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :[%SYSTEMDRIVE%] (ETCs)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\DIRDEL_ROOT_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		TITLE �˻���^(DB^) "%SYSTEMDRIVE%%%A" 2>Nul
		IF EXIST "%SYSTEMDRIVE%%%A\" (
			>VARIABLE\TXT1 ECHO %SYSTEMDRIVE%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
	)
)
REM :[%SYSTEMDRIVE%] (for 1-Step)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %SYSTEMDRIVE%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMDRIVE%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_ROOT.DB 2^>Nul') DO (
	IF /I NOT "%SYSTEMDRIVE%\%%A" == "%SYSTEMROOT%" (
		TITLE �˻��� "%SYSTEMDRIVE%\%%A" 2>Nul
		>VARIABLE\TXT2 ECHO %%A
		IF EXIST "%SYSTEMDRIVE%\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_ROOT_1STEP.DB VARIABLE\TXT2 2^>Nul') DO (
				FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMDRIVE%\%%A\" 2^>Nul') DO (
					>VARIABLE\TXTX ECHO %%B
					FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\DIRECTORY\DEL_ROOT_1STEP_FORFILE.DB VARIABLE\TXTX 2^>Nul') DO (
						FOR /F %%Z IN ('DIR /B /A-D "%SYSTEMDRIVE%\%%A\" 2^>Nul^|TOOLS\GREP\GREP.EXE -c "" 2^>Nul') DO (
							IF %%Z LSS 5 CALL :DEL_DIRT ACTIVESCAN
						)
					)
				)
			)
		)
	)
)
REM :[%SYSTEMROOT%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_SYSTEMROOT.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_SYSTEMROOT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%SYSTEMROOT%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_SYSTEMROOT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%] (ETCs)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\DIRDEL_SYSTEMROOT_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		TITLE �˻���^(DB^) "%SYSTEMROOT%%%A" 2>Nul
		IF EXIST "%SYSTEMROOT%%%A\" (
			>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
	)
)
REM :[%SYSTEMROOT%]\System32
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\System32\" 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\System32\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_SYSTEM6432.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%SYSTEMROOT%\System32\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_SYSTEM6432.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%]\SysWOW64
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\SysWOW64\" 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\SysWOW64\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_SYSTEM6432.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_SYSTEM6432.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :[%ALLUSERSPROFILE%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%ALLUSERSPROFILE%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_APPDATA.DB 2^>Nul') DO (
	TITLE �˻��� "%ALLUSERSPROFILE%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%ALLUSERSPROFILE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_ALLUSERSPROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%ALLUSERSPROFILE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_PROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%ALLUSERSPROFILE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%ALLUSERSPROFILE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\DIRECTORY\DEL_ADWARE_XYZ.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%ALLUSERSPROFILE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%ALLUSERSPROFILE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%ALLUSERSPROFILE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_ALLUSERSPROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%ALLUSERSPROFILE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%ALLUSERSPROFILE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%ALLUSERSPROFILE%\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%ALLUSERSPROFILE%\%%A\" 2^>Nul') DO (
			TITLE �˻��� "%ALLUSERSPROFILE%\%%A" "%%B" 2>Nul
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%ALLUSERSPROFILE%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :[%LOCALAPPDATA%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_APPDATA.DB 2^>Nul') DO (
	TITLE �˻��� "%LOCALAPPDATA%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%LOCALAPPDATA%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%LOCALAPPDATA%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%LOCALAPPDATA%\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%LOCALAPPDATA%\%%A\" 2^>Nul') DO (
			TITLE �˻��� "%LOCALAPPDATA%\%%A" "%%B" 2>Nul
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%LOCALAPPDATA%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :[%LOCALLOWAPPDATA%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALLOWAPPDATA%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALLOWAPPDATA%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_APPDATA.DB 2^>Nul') DO (
	TITLE �˻��� "%LOCALLOWAPPDATA%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALLOWAPPDATA%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%LOCALLOWAPPDATA%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%LOCALLOWAPPDATA%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%LOCALLOWAPPDATA%\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%LOCALLOWAPPDATA%\%%A\" 2^>Nul') DO (
			TITLE �˻��� "%LOCALLOWAPPDATA%\%%A" "%%B" 2>Nul
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%LOCALLOWAPPDATA%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :[%APPDATA%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%APPDATA%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_APPDATA.DB 2^>Nul') DO (
	TITLE �˻��� "%APPDATA%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%APPDATA%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%APPDATA%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%APPDATA%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%APPDATA%\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%APPDATA%\%%A\" 2^>Nul') DO (
			TITLE �˻��� "%APPDATA%\%%A" "%%B" 2>Nul
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%APPDATA%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :[%SYSTEMROOT%]\System32\Config\SystemProfile\AppData\Local
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_APPDATA.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\%%A\" 2^>Nul') DO (
			TITLE �˻��� "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\%%A" "%%B" 2>Nul
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :[%SYSTEMROOT%]\SysWOW64\Config\SystemProfile\AppData\Local
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_APPDATA.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\%%A\" 2^>Nul') DO (
			TITLE �˻��� "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\%%A" "%%B" 2>Nul
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :[%SYSTEMROOT%]\System32\Config\SystemProfile\AppData\LocalLow
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_APPDATA.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\%%A\" 2^>Nul') DO (
			TITLE �˻��� "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\%%A" "%%B" 2>Nul
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :[%SYSTEMROOT%]\SysWOW64\Config\SystemProfile\AppData\LocalLow
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_APPDATA.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\%%A\" 2^>Nul') DO (
			TITLE �˻��� "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\%%A" "%%B" 2>Nul
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :[%SYSTEMROOT%]\System32\Config\SystemProfile\AppData\Roaming
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_APPDATA.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\%%A\" 2^>Nul') DO (
			TITLE �˻��� "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\%%A" "%%B" 2>Nul
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :[%SYSTEMROOT%]\SysWOW64\Config\SystemProfile\AppData\Roaming
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_APPDATA.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\%%A\" 2^>Nul') DO (
			TITLE �˻��� "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\%%A" "%%B" 2>Nul
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :[%USERPROFILE%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKUSERPROFILE%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%USERPROFILE%\" 2^>Nul') DO (
	TITLE �˻��� "%USERPROFILE%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%USERPROFILE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_PROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%USERPROFILE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :[%PUBLIC%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKPUBLIC%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%PUBLIC%\" 2^>Nul') DO (
	TITLE �˻��� "%PUBLIC%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%PUBLIC%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_PROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%PUBLIC%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :[%USERPROFILE%]\AppData
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKUSERPROFILE%\AppData\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%USERPROFILE%\AppData\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_APPDATA.DB 2^>Nul') DO (
	TITLE �˻��� "%USERPROFILE%\AppData\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%USERPROFILE%\AppData\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
)
REM :[%ALLUSERSPROFILE%]\Start Menu\Programs
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Start Menu\Programs\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%ALLUSERSPROFILE%\Start Menu\Programs\" 2^>Nul') DO (
	TITLE �˻��� "%ALLUSERSPROFILE%\Start Menu\Programs\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%ALLUSERSPROFILE%\Start Menu\Programs\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\DIRECTORY\DEL_STARTMENU_PROGRAMS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
)
REM :[%APPDATA%]\Microsoft\Windows\Start Menu\Programs
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Microsoft\Windows\Start Menu\Programs\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%APPDATA%\Microsoft\Windows\Start Menu\Programs\" 2^>Nul') DO (
	TITLE �˻��� "%APPDATA%\Microsoft\Windows\Start Menu\Programs\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%APPDATA%\Microsoft\Windows\Start Menu\Programs\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\DIRECTORY\DEL_STARTMENU_PROGRAMS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
)
REM :Profiles (ETCs)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\DIRDEL_PROFILE_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		TITLE �˻���^(DB^) "%ALLUSERSPROFILE%%%A" 2>Nul
		IF EXIST "%ALLUSERSPROFILE%%%A\" (
			>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_DIRT
		)
		TITLE �˻���^(DB^) "%USERPROFILE%%%A" 2>Nul
		IF EXIST "%USERPROFILE%%%A\" (
			>VARIABLE\TXT1 ECHO %MZKUSERPROFILE%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_DIRT
		)
		TITLE �˻���^(DB^) "%PUBLIC%%%A" 2>Nul
		IF EXIST "%PUBLIC%%%A\" (
			>VARIABLE\TXT1 ECHO %MZKPUBLIC%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_DIRT
		)
	)
)
REM :Browser Extensions - Chrome Plus (Databases)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Databases\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Databases\" 2^>Nul') DO (
	TITLE �˻��� "%LOCALAPPDATA%\MapleStudio\ChromePlus\��������\Databases\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "TOKENS=2 DELIMS=_" %%B IN ('ECHO %%A') DO (
		>VARIABLE\TXTX ECHO %%B
		IF EXIST "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Databases\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_DIRT
		)
		IF EXIST DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB (
			IF EXIST "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Databases\%%A\" (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :Browser Extensions - Chrome Plus (Extensions)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Extensions\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Extensions\" 2^>Nul') DO (
	TITLE �˻��� "%LOCALAPPDATA%\MapleStudio\ChromePlus\��������\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Extensions\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB (
		IF EXIST "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Extensions\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
		)
	)
)
REM :Browser Extensions - Chrome Plus (Local Extension Settings)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Local Extension Settings\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Local Extension Settings\" 2^>Nul') DO (
	TITLE �˻��� "%LOCALAPPDATA%\MapleStudio\ChromePlus\��������\Local Extension Settings\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Local Extension Settings\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB (
		IF EXIST "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Local Extension Settings\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
		)
	)
)
REM :Browser Extensions - Chromium (Databases)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Chromium\User Data\Default\Databases\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Chromium\User Data\Default\Databases\" 2^>Nul') DO (
	TITLE �˻��� "%LOCALAPPDATA%\Chromium\��������\Databases\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "TOKENS=2 DELIMS=_" %%B IN ('ECHO %%A') DO (
		>VARIABLE\TXTX ECHO %%B
		IF EXIST "%LOCALAPPDATA%\Chromium\User Data\Default\Databases\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_DIRT
		)
		IF EXIST DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB (
			IF EXIST "%LOCALAPPDATA%\Chromium\User Data\Default\Databases\%%A\" (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :Browser Extensions - Chromium (Extensions)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Chromium\User Data\Default\Extensions\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Chromium\User Data\Default\Extensions\" 2^>Nul') DO (
	TITLE �˻��� "%LOCALAPPDATA%\Chromium\��������\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\Chromium\User Data\Default\Extensions\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB (
		IF EXIST "%LOCALAPPDATA%\Chromium\User Data\Default\Extensions\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
		)
	)
)
REM :Browser Extensions - Chromium (Local Extension Settings)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Chromium\User Data\Default\Local Extension Settings\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Chromium\User Data\Default\Local Extension Settings\" 2^>Nul') DO (
	TITLE �˻��� "%LOCALAPPDATA%\Chromium\��������\Local Extension Settings\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\Chromium\User Data\Default\Local Extension Settings\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB (
		IF EXIST "%LOCALAPPDATA%\Chromium\User Data\Default\Local Extension Settings\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
		)
	)
)
REM :Browser Extensions - COMODO Dragon (Databases)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\COMODO\Dragon\User Data\Default\Databases\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Databases\" 2^>Nul') DO (
	TITLE �˻��� "%LOCALAPPDATA%\COMODO\Dragon\��������\Databases\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "TOKENS=2 DELIMS=_" %%B IN ('ECHO %%A') DO (
		>VARIABLE\TXTX ECHO %%B
		IF EXIST "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Databases\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_DIRT
		)
		IF EXIST DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB (
			IF EXIST "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Databases\%%A\" (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :Browser Extensions - COMODO Dragon (Extensions)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\COMODO\Dragon\User Data\Default\Extensions\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Extensions\" 2^>Nul') DO (
	TITLE �˻��� "%LOCALAPPDATA%\COMODO\Dragon\��������\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Extensions\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB (
		IF EXIST "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Extensions\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
		)
	)
)
REM :Browser Extensions - COMODO Dragon (Local Extension Settings)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\COMODO\Dragon\User Data\Default\Local Extension Settings\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Local Extension Settings\" 2^>Nul') DO (
	TITLE �˻��� "%LOCALAPPDATA%\COMODO\Dragon\��������\Local Extension Settings\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Local Extension Settings\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Local Extension Settings\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :Browser Extensions - Google Chrome (Databases)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Google\Chrome\User Data\Default\Databases\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Databases\" 2^>Nul') DO (
	TITLE �˻��� "%LOCALAPPDATA%\Google\Chrome\��������\Databases\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "TOKENS=2 DELIMS=_" %%B IN ('ECHO %%A') DO (
		>VARIABLE\TXTX ECHO %%B
		IF EXIST "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Databases\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_DIRT
		)
		IF EXIST "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Databases\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
		)
	)
)
REM :Browser Extensions - Google Chrome (Extensions)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Google\Chrome\User Data\Default\Extensions\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Extensions\" 2^>Nul') DO (
	TITLE �˻��� "%LOCALAPPDATA%\Google\Chrome\��������\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Extensions\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Extensions\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :Browser Extensions - Google Chrome (Local Extension Settings)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Google\Chrome\User Data\Default\Local Extension Settings\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Local Extension Settings\" 2^>Nul') DO (
	TITLE �˻��� "%LOCALAPPDATA%\Google\Chrome\��������\Local Extension Settings\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Local Extension Settings\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Local Extension Settings\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :Browser Extensions - Google Chrome SxS (Databases)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Databases\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Databases\" 2^>Nul') DO (
	TITLE �˻��� "%LOCALAPPDATA%\Google\Chrome SxS\��������\Databases\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "TOKENS=2 DELIMS=_" %%B IN ('ECHO %%A') DO (
		IF EXIST "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Databases\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
		)
		IF EXIST "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Databases\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
		)
	)
)
REM :Browser Extensions - Google Chrome SxS (Extensions)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Extensions\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Extensions\" 2^>Nul') DO (
	TITLE �˻��� "%LOCALAPPDATA%\Google\Chrome SxS\��������\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Extensions\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Extensions\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :Browser Extensions - Google Chrome SxS (Local Extension Settings)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Local Extension Settings\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Local Extension Settings\" 2^>Nul') DO (
	TITLE �˻��� "%LOCALAPPDATA%\Google\Chrome SxS\��������\Local Extension Settings\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Local Extension Settings\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Local Extension Settings\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :Browser Extensions - Opera
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Opera Software\Opera Stable\Extensions\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%APPDATA%\Opera Software\Opera Stable\Extensions\" 2^>Nul') DO (
	TITLE �˻��� "%APPDATA%\Opera Software\Opera Stable\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%APPDATA%\Opera Software\Opera Stable\Extensions\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%APPDATA%\Opera Software\Opera Stable\Extensions\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :Browser Extensions - Mozilla Firefox
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%APPDATA%\Mozilla\Firefox\Profiles\" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Mozilla\Firefox\Profiles\%%A\Extensions\
	FOR /F "DELIMS=" %%B IN ('DIR /B /AD "%APPDATA%\Mozilla\Firefox\Profiles\%%A\Extensions\" 2^>Nul') DO (
		TITLE �˻��� "%APPDATA%\Mozilla\Firefox\��������\%%A\Extensions\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%APPDATA%\Mozilla\Firefox\Profiles\%%A\Extensions\%%B\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_FIREFOX.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
		)
		IF EXIST "%APPDATA%\Mozilla\Firefox\Profiles\%%A\Extensions\%%B\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_BROWSER_EXTENSIONS_FIREFOX.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
		)
	)
)
REM :Application Data (ETCs)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\DIRDEL_APPDATA_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		TITLE �˻���^(DB^) "%ALLUSERSPROFILE%%%A" 2>Nul
		IF EXIST "%ALLUSERSPROFILE%%%A\" (
			>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_DIRT
		)
		TITLE �˻���^(DB^) "%ALLUSERSPROFILE%\Application Data%%A" 2>Nul
		IF EXIST "%ALLUSERSPROFILE%\Application Data%%A\" (
			>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Application Data%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_DIRT
		)
		TITLE �˻���^(DB^) "%LOCALAPPDATA%%%A" 2>Nul
		IF EXIST "%LOCALAPPDATA%%%A\" (
			>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_DIRT
		)
		TITLE �˻���^(DB^) "%LOCALLOWAPPDATA%%%A" 2>Nul
		IF EXIST "%LOCALLOWAPPDATA%%%A\" (
			>VARIABLE\TXT1 ECHO %MZKLOCALLOWAPPDATA%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_DIRT
		)
		TITLE �˻���^(DB^) "%APPDATA%%%A" 2>Nul
		IF EXIST "%APPDATA%\%%A\" (
			>VARIABLE\TXT1 ECHO %MZKAPPDATA%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_DIRT
		)
	)
)
REM :[%PROGRAMFILES%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKPROGRAMFILES%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%PROGRAMFILES%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_PROGRAMFILES.DB 2^>Nul') DO (
	TITLE �˻��� "%PROGRAMFILES%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%PROGRAMFILES%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_PROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%PROGRAMFILES%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\DIRECTORY\DEL_ADWARE_XYZ.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%PROGRAMFILES%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%PROGRAMFILES%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%PROGRAMFILES%\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%PROGRAMFILES%\%%A\" 2^>Nul') DO (
			TITLE �˻��� "%PROGRAMFILES%\%%A" "%%B" 2>Nul
			>VARIABLE\TXTX ECHO %%B
			IF EXIST "%PROGRAMFILES%\%%A\" (
				FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%PROGRAMFILES%\%%A\%%B" 2^>Nul') DO (
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROGRAMFILES_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
				)
			)
			IF EXIST "%PROGRAMFILES%\%%A\" (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROGRAMFILES_1STEP_SCANONLY.DB VARIABLE\TXT2 2^>Nul') DO (
					FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROGRAMFILES_1STEP_HYENA_FORFILE.DB VARIABLE\TXTX 2^>Nul') DO (
						FOR /F %%Z IN ('DIR /B /A-D "%PROGRAMFILES%\%%A\" 2^>Nul^|TOOLS\GREP\GREP.EXE -c "" 2^>Nul') DO (
							IF %%Z LSS 5 CALL :DEL_DIRT ACTIVESCAN
						)
					)
				)
			)
		)
	)
)
REM :[%PROGRAMFILESX86%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKPROGRAMFILESX86%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%PROGRAMFILESX86%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_PROGRAMFILES.DB 2^>Nul') DO (
	TITLE �˻��� "%PROGRAMFILESX86%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%PROGRAMFILESX86%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_PROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%PROGRAMFILESX86%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\DIRECTORY\DEL_ADWARE_XYZ.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%PROGRAMFILESX86%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%PROGRAMFILESX86%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%PROGRAMFILESX86%\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%PROGRAMFILESX86%\%%A\" 2^>Nul') DO (
			TITLE �˻��� "%PROGRAMFILESX86%\%%A" "%%B" 2>Nul
			>VARIABLE\TXTX ECHO %%B
			IF EXIST "%PROGRAMFILESX86%\%%A\" (
				FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%PROGRAMFILESX86%\%%A\%%B" 2^>Nul') DO (
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROGRAMFILES_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
				)
			)
			IF EXIST "%PROGRAMFILESX86%\%%A\" (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROGRAMFILES_1STEP_SCANONLY.DB VARIABLE\TXT2 2^>Nul') DO (
					FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROGRAMFILES_1STEP_HYENA_FORFILE.DB VARIABLE\TXTX 2^>Nul') DO (
						FOR /F %%Z IN ('DIR /B /A-D "%PROGRAMFILESX86%\%%A\" 2^>Nul^|TOOLS\GREP\GREP.EXE -c "" 2^>Nul') DO (
							IF %%Z LSS 5 CALL :DEL_DIRT ACTIVESCAN
						)
					)
				)
			)
		)
	)
)
REM :[%COMMONPROGRAMFILES%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILES%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%COMMONPROGRAMFILES%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_COMMONPROGRAMFILES.DB 2^>Nul') DO (
	TITLE �˻��� "%COMMONPROGRAMFILES%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%COMMONPROGRAMFILES%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_COMMONPROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%COMMONPROGRAMFILES%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_COMMONPROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :[%COMMONPROGRAMFILESX86%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILESX86%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%COMMONPROGRAMFILESX86%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_COMMONPROGRAMFILES.DB 2^>Nul') DO (
	TITLE �˻��� "%COMMONPROGRAMFILESX86%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%COMMONPROGRAMFILESX86%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_COMMONPROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%COMMONPROGRAMFILESX86%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_COMMONPROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :[%PROGRAMFILES%], [%PROGRAMFILESX86%] (ETCs)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\DIRDEL_PROGRAMFILES_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		TITLE �˻���^(DB^) "%PROGRAMFILES%%%A" 2>Nul
		IF EXIST "%PROGRAMFILES%%%A\" (
			>VARIABLE\TXT1 ECHO %MZKPROGRAMFILES%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_DIRT
		)
		TITLE �˻���^(DB^) "%PROGRAMFILESX86%%%A" 2>Nul
		IF EXIST "%PROGRAMFILESX86%%%A" (
			>VARIABLE\TXT1 ECHO %MZKPROGRAMFILESX86%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_DIRT
		)
	)
)
REM :(Active Scan) [%SYSTEMDRIVE%] (Hidden)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %SYSTEMDRIVE%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AHD "%SYSTEMDRIVE%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_ROOT.DB 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMDRIVE%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMDRIVE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_ROOT_ONLYHIDDEN.DB VARIABLE\TXT2 2^>Nul') DO (
			FOR /F %%Y IN ('DIR /B /A-D "%SYSTEMDRIVE%\%%A\" 2^>Nul^|TOOLS\GREP\GREP.EXE -c "" 2^>Nul') DO (
				IF %%Y LSS 5 CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :(Active Scan) [%SYSTEMROOT%]
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\" 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\%%A" 2>Nul
	SETLOCAL ENABLEDELAYEDEXPANSION
	ECHO "%%A"|TOOLS\GREP\GREP.EXE -xq "^\(\""\([0-9A-F]\{8\}\)\""\)$" >Nul 2>Nul
	IF !ERRORLEVEL! EQU 0 (
		ENDLOCAL
		FOR /F "DELIMS=" %%X IN ('DIR /B /A-D "%SYSTEMROOT%\%%A\" 2^>Nul') DO (
			SETLOCAL ENABLEDELAYEDEXPANSION
			ECHO "%%X"|TOOLS\GREP\GREP.EXE -ixq "^\(\""\(SVCHSOT\.EXE\)\""\)$" >Nul 2>Nul
			IF !ERRORLEVEL! EQU 0 (
				ENDLOCAL
				>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\
				>VARIABLE\TXT2 ECHO %%A
				CALL :DEL_DIRT ACTIVESCAN
			) ELSE (
				ENDLOCAL
			)
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\addins
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\addins\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\addins\" 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\addins\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\addins\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_SYSTEMROOT_ADDINS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\AppPatch
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\AppPatch\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\AppPatch\" 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\AppPatch\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\AppPatch\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_SYSTEMROOT_APPPATCH.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\Downloaded Program Files
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\Downloaded Program Files\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\Downloaded Program Files\" 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\Downloaded Program Files\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\Downloaded Program Files\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_DOWNLOADEDPROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\MUI
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\MUI\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\MUI\" 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\MUI\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\MUI\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_SYSTEMROOT_MUI.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\Web
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\Web\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\Web\" 2^>Nul') DO (
	TITLE �˻��� "%SYSTEMROOT%\Web\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\Web\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_SYSTEMROOT_WEB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :(Active Scan) [%COMMONPROGRAMFILES%] (for 1-Step & MD5)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILES%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%COMMONPROGRAMFILES%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_COMMONPROGRAMFILES.DB 2^>Nul') DO (
	TITLE �˻��� "%COMMONPROGRAMFILES%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_COMMONPROGRAMFILES_1STEP.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%COMMONPROGRAMFILES%\%%A\" 2^>Nul') DO (
			>VARIABLE\TXTX ECHO %%B
			IF EXIST "%COMMONPROGRAMFILES%\%%A\" (
				FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\DIRECTORY\DEL_COMMONPROGRAMFILES_1STEP_FORFILE.DB VARIABLE\TXTX 2^>Nul') DO (
					FOR /F %%Z IN ('DIR /B /A-D "%COMMONPROGRAMFILES%\%%A\" 2^>Nul^|TOOLS\GREP\GREP.EXE -c "" 2^>Nul') DO (
						IF %%Z LSS 5 CALL :DEL_DIRT ACTIVESCAN
					)
				)
			)
			IF EXIST "%COMMONPROGRAMFILES%\%%A\" (
				FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%COMMONPROGRAMFILES%\%%A\%%B" 2^>Nul') DO (
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\THREAT\DIRECTORY\DEL_COMMONPROGRAMFILES_1STEP_FORFILE_MD5.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
				)
			)
		)
	)
)
REM :(Active Scan) [%COMMONPROGRAMFILESX86%] (for 1-Step & MD5)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILESX86%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%COMMONPROGRAMFILESX86%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_COMMONPROGRAMFILES.DB 2^>Nul') DO (
	TITLE �˻��� "%COMMONPROGRAMFILESX86%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_COMMONPROGRAMFILES_1STEP.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%COMMONPROGRAMFILESX86%\%%A\" 2^>Nul') DO (
			>VARIABLE\TXTX ECHO %%B
			IF EXIST "%COMMONPROGRAMFILESX86%\%%A\" (
				FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\DIRECTORY\DEL_COMMONPROGRAMFILES_1STEP_FORFILE.DB VARIABLE\TXTX 2^>Nul') DO (
					FOR /F %%Z IN ('DIR /B /A-D "%COMMONPROGRAMFILESX86%\%%A\" 2^>Nul^|TOOLS\GREP\GREP.EXE -c "" 2^>Nul') DO (
						IF %%Z LSS 5 CALL :DEL_DIRT ACTIVESCAN
					)
				)
			)
			IF EXIST "%COMMONPROGRAMFILESX86%\%%A\" (
				FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%COMMONPROGRAMFILESX86%\%%A\%%B" 2^>Nul') DO (
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\THREAT\DIRECTORY\DEL_COMMONPROGRAMFILES_1STEP_FORFILE_MD5.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
				)
			)
		)
	)
)
REM :(Active Scan) D:\Program Files (for 1-Step & MD5)
IF /I "%DDRV%" == "TRUE" (
	IF /I NOT "%PROGRAMFILES%" == "D:\Program Files" (
		TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
		>VARIABLE\TXT1 ECHO D:\Program Files\
		FOR /F "DELIMS=" %%A IN ('DIR /B /AD "D:\Program Files\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_PROGRAMFILES.DB 2^>Nul') DO (
			TITLE �˻��� "D:\Program Files\%%A" 2>Nul
			>VARIABLE\TXT2 ECHO %%A
			FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "D:\Program Files\%%A\" 2^>Nul') DO (
				TITLE �˻��� "D:\Program Files\%%A" "%%B" 2>Nul
				>VARIABLE\TXTX ECHO %%B
				IF EXIST "D:\Program Files\%%A\" (
					FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "D:\Program Files\%%A\%%B" 2^>Nul') DO (
						FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROGRAMFILES_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
					)
				)
				IF EXIST "D:\Program Files\%%A\" (
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROGRAMFILES_1STEP_HYENA_FORFILE.DB VARIABLE\TXTX 2^>Nul') DO (
						FOR /F %%Y IN ('DIR /B /A-D "D:\Program Files\%%A\" 2^>Nul^|TOOLS\GREP\GREP.EXE -c "" 2^>Nul') DO (
							IF %%Y LSS 5 CALL :DEL_DIRT ACTIVESCAN
						)
					)
				)
			)
		)
	)
)
REM :Static
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\THREAT\DIRECTORY\DEL_STATIC.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ MZK THREAT DIRECTORY DEL_STATIC.DB ~~~~~~~~~~" (
		TITLE �˻���^(DB^) "%%A" 2>Nul
		IF EXIST "%%A\" (
			>VARIABLE\TXT1 ECHO %%~dpA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_DIRT
		)
	)
)
REM :Result
CALL :P_RESULT RECK CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Malicious Hosts File Delete
ECHO �� �Ǽ� ȣ��Ʈ ���� ������ . . . & >>"%QLog%" ECHO    �� �Ǽ� ȣ��Ʈ ���� ���� :
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\Drivers\etc\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\System32\Drivers\etc\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_DRIVERS_ETC.DB 2^>Nul') DO (
	TITLE �˻��� "%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\Drivers\etc\%%A" (
		>VARIABLE\CHCK ECHO 0
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fif DB_EXEC\CHECK\CHK_HOSTS_STRING.DB "%SYSTEMROOT%\System32\Drivers\etc\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -v "^#" 2^>Nul') DO (
			SETLOCAL ENABLEDELAYEDEXPANSION
			<VARIABLE\CHCK SET /P CHCK=
			IF !CHCK! EQU 0 (
				ENDLOCAL
				>VARIABLE\CHCK ECHO 1
				CALL :DEL_FILE
			) ELSE (
				ENDLOCAL
			)
		)
	)
)
IF NOT EXIST "%SYSTEMROOT%\System32\Drivers\etc\hosts" (
	COPY /Y REPAIR\hosts "%SYSTEMROOT%\System32\Drivers\etc\" >Nul 2>Nul
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Reset Network DNS Address <#1>
ECHO �� ��Ʈ��ũ DNS �ּ� ���� Ȯ���� - 1�� . . . & >>"%QLog%" ECHO    �� ��Ʈ��ũ DNS �ּ� ���� Ȯ�� - 1�� :
TITLE ^(Ȯ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %%A
	FOR /F "TOKENS=1,2 DELIMS=," %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%A\NameServer" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
		IF NOT "%%B" == "" (
			IF NOT "%%C" == "" (
				>VARIABLE\TXT2 ECHO %%B^|%%C
				>VARIABLE\TXTX ECHO %%B,%%C
				IF "%%B" == "%%C" (
					CALL :RESETDNS
				) ELSE (
					>VARIABLE\CHCK ECHO 0
					SETLOCAL ENABLEDELAYEDEXPANSION
					<VARIABLE\CHCK SET /P CHCK=
					IF !CHCK! EQU 0 (
						ENDLOCAL
						FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\NETWORK\DEL_DNS_ADDRESS.DB VARIABLE\TXTX 2^>Nul') DO CALL :RESETDNS
					) ELSE (
						ENDLOCAL
					)
					SETLOCAL ENABLEDELAYEDEXPANSION
					<VARIABLE\CHCK SET /P CHCK=
					IF !CHCK! EQU 0 (
						ENDLOCAL
						FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\NETWORK\PATTERN_DNS_ADDRESS.DB VARIABLE\TXTX 2^>Nul') DO CALL :RESETDNS
					) ELSE (
						ENDLOCAL
					)
				)
			) ELSE (
				>VARIABLE\TXT2 ECHO %%B
				>VARIABLE\CHCK ECHO 0
				SETLOCAL ENABLEDELAYEDEXPANSION
				<VARIABLE\CHCK SET /P CHCK=
				IF !CHCK! EQU 0 (
					ENDLOCAL
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\NETWORK\DEL_DNS_ADDRESS.DB VARIABLE\TXT2 2^>Nul') DO CALL :RESETDNS
				) ELSE (
					ENDLOCAL
				)
				SETLOCAL ENABLEDELAYEDEXPANSION
				<VARIABLE\CHCK SET /P CHCK=
				IF !CHCK! EQU 0 (
					ENDLOCAL
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\NETWORK\PATTERN_DNS_ADDRESS.DB VARIABLE\TXT2 2^>Nul') DO CALL :RESETDNS
				) ELSE (
					ENDLOCAL
				)
			)
		)
	)
)
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\CHCK SET /P CHCK=
IF !CHCK! EQU 0 (
	ENDLOCAL
	ECHO    �������� �߰ߵ��� �ʾҽ��ϴ�. & >>"%QLog%" ECHO    �������� �߰ߵ��� ����
) ELSE (
	ENDLOCAL
	>VARIABLE\XXYY ECHO 1
)
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Reset WinSock Protocol
ECHO �� ���� �������� ���� Ȯ���� . . . & >>"%QLog%" ECHO    �� ���� �������� ���� Ȯ�� :
TITLE ^(Ȯ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('NETSH.EXE WINSOCK SHOW CATALOG 2^>Nul^|TOOLS\GREP\GREP.EXE -i "^\(Provider Path:\|Provider Path :\|������ ���:\|������ ��� :\)" 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%~nxA
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\NETWORK\DEL_BAD_WINSOCK_PROTOCOL.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\CHCK ECHO 1
		SETLOCAL ENABLEDELAYEDEXPANSION
		NETSH.EXE WINSOCK RESET >Nul 2>Nul
		IF !ERRORLEVEL! EQU 0 (
			ECHO    ������ ���� �߰ߵǾ� �ʱ�ȭ�� �����մϴ�. ^(����� �ʿ�^) & >>"!QLog!" ECHO    ������ ���� �߰ߵǾ� �ʱ�ȭ ���� ^(����� �ʿ�^)
		) ELSE (
			ECHO    ������ ���� �߰ߵǾ� �ʱ�ȭ�� �����Ͽ����� ������ �߻��߽��ϴ�. & >>"!QLog!" ECHO    ������ ���� �߰ߵǾ� �ʱ�ȭ ���� ^(���� - ���� �߻�^)
		)
		ENDLOCAL & GOTO RS_WSLSP
	)
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\NETWORK\PATTERN_BAD_WINSOCK_PROTOCOL.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\CHCK ECHO 1
		SETLOCAL ENABLEDELAYEDEXPANSION
		NETSH.EXE WINSOCK RESET >Nul 2>Nul
		IF !ERRORLEVEL! EQU 0 (
			ECHO    ������ ���� �߰ߵǾ� �ʱ�ȭ�� �����մϴ�. ^(����� �ʿ�^) & >>"!QLog!" ECHO    ������ ���� �߰ߵǾ� �ʱ�ȭ ���� ^(����� �ʿ�^)
		) ELSE (
			ECHO    ������ ���� �߰ߵǾ� �ʱ�ȭ�� �����Ͽ����� ������ �߻��߽��ϴ�. & >>"!QLog!" ECHO    ������ ���� �߰ߵǾ� �ʱ�ȭ ���� ^(���� - ���� �߻�^)
		)
		ENDLOCAL & GOTO RS_WSLSP
	)
)
:RS_WSLSP
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\CHCK SET /P CHCK=
IF !CHCK! EQU 0 (
	ECHO    �������� �߰ߵ��� �ʾҽ��ϴ�. & >>"%QLog%" ECHO    �������� �߰ߵ��� ����
) ELSE (
	>VARIABLE\XXYY ECHO 1
)
ENDLOCAL
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Delete - Registry <HKEY_CLASSES_ROOT>
ECHO �� �Ǽ� �� ���� ���� ^<HKEY_CLASSES_ROOT^> ������Ʈ�� ������ . . . & >>"%QLog%" ECHO    �� �Ǽ� �� ���� ���� ^<HKEY_CLASSES_ROOT^> ������Ʈ�� ���� :
REM :HKCR
TITLE ���� �˻��� "HKCR" / ���¿� ���� �ð��� �ҿ�� �� ���� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCR
SET "STRTMP=HKCR"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCR" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -ivxf DB\EXCEPT\EX_REG_HK_PATTERN.DB 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCR\APPID
TITLE ���� �˻��� "HKCR\APPID" / ���¿� ���� �ð��� �ҿ�� �� ���� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCR\APPID
SET "STRTMP=HKCR_APPID"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCR\APPID" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_APPID.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_APPID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKCR\Wow6432Node\APPID
TITLE ���� �˻��� "HKCR\Wow6432Node\APPID" / ���¿� ���� �ð��� �ҿ�� �� ���� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCR\Wow6432Node\APPID
SET "STRTMP=HKCR_APPID(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCR\Wow6432Node\APPID" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_APPID.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_APPID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKCR\CLSID
TITLE ���� �˻��� "HKCR\CLSID" / ���¿� ���� �ð��� �ҿ�� �� ���� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCR\CLSID
SET "STRTMP=HKCR_CLSID"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCR\CLSID" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_CLSID.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		CALL :GET_DVAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fxf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID_DEFAULTVAL.DB VARIABLE\TXTX 2^>Nul') DO (
			>>DB_ACTIVE\ACT_HK_CLSID.DB ECHO %%A
			CALL :DEL_REGK NULL BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		CALL :GET_DVAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXTX 2^>Nul') DO (
			>>DB_ACTIVE\ACT_HK_CLSID.DB ECHO %%A
			CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCR\Wow6432Node\CLSID
TITLE ���� �˻��� "HKCR\Wow6432Node\CLSID" / ���¿� ���� �ð��� �ҿ�� �� ���� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCR\Wow6432Node\CLSID
SET "STRTMP=HKCR_CLSID(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCR\Wow6432Node\CLSID" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_CLSID.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		CALL :GET_DVAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fxf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID_DEFAULTVAL.DB VARIABLE\TXTX 2^>Nul') DO (
			>>DB_ACTIVE\ACT_HK_CLSID.DB ECHO %%A
			CALL :DEL_REGK NULL BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		CALL :GET_DVAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXTX 2^>Nul') DO (
			>>DB_ACTIVE\ACT_HK_CLSID.DB ECHO %%A
			CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCR\Interface
TITLE ���� �˻��� "HKCR\Interface" / ���¿� ���� �ð��� �ҿ�� �� ���� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCR\Interface
SET "STRTMP=HKCR_Interface"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCR\Interface" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_INTERFACE.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_INTERFACE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_INTERFACE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCR\Wow6432Node\Interface
TITLE ���� �˻��� "HKCR\Wow6432Node\Interface" / ���¿� ���� �ð��� �ҿ�� �� ���� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCR\Wow6432Node\Interface
SET "STRTMP=HKCR_Interface(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCR\Wow6432Node\Interface" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_INTERFACE.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_INTERFACE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_INTERFACE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCR\TypeLib
TITLE ���� �˻��� "HKCR\TypeLib" / ���¿� ���� �ð��� �ҿ�� �� ���� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCR\TypeLib
SET "STRTMP=HKCR_TypeLib"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCR\TypeLib" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_TYPELIB.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_TYPELIB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_TYPELIB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCR\Wow6432Node\TypeLib
TITLE ���� �˻��� "HKCR\Wow6432Node\TypeLib" / ���¿� ���� �ð��� �ҿ�� �� ���� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCR\Wow6432Node\TypeLib
SET "STRTMP=HKCR_TypeLib(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCR\Wow6432Node\TypeLib" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_TYPELIB.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_TYPELIB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_TYPELIB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCR (ETCs)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "TOKENS=1,2 DELIMS=|" %%A IN (DB_EXEC\REGDEL_HKCR_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		IF NOT "%%B" == "" (
			TITLE �˻���^(DB^) "HKCR\%%A : %%~nxB" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCR\%%A\%%B" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKCR\%%A
				>VARIABLE\TXT2 ECHO %%B
				CALL :DEL_REGV NULL BACKUP RANDOM "HKCR_ETCS"
			)
			TITLE �˻���^(DB^) "HKCR\Wow6432Node\%%A : %%~nxB" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCR\Wow6432Node\%%A\%%B" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKCR\Wow6432Node\%%A
				>VARIABLE\TXT2 ECHO %%B
				CALL :DEL_REGV NULL BACKUP RANDOM "HKCR_ETCS(x86)"
			)
		) ELSE (
			TITLE �˻���^(DB^) "HKCR\%%A" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -v -q check "\HKCR\%%A" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKCR
				>VARIABLE\TXT2 ECHO %%A
				CALL :DEL_REGK NULL BACKUP "HKCR_ETCS"
			)
			TITLE �˻���^(DB^) "HKCR\Wow6432Node\%%A" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -v -q check "\HKCR\Wow6432Node\%%A" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKCR\Wow6432Node
				>VARIABLE\TXT2 ECHO %%A
				CALL :DEL_REGK NULL BACKUP "HKCR_ETCS(x86)"
			)
		)
	)
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Delete - Registry <HKEY_CURRENT_USER>
ECHO �� �Ǽ� �� ���� ���� ^<HKEY_CURRENT_USER^> ������Ʈ�� ������ . . . & >>"%QLog%" ECHO    �� �Ǽ� �� ���� ���� ^<HKEY_CURRENT_USER^> ������Ʈ�� ���� :
REM :HKCU\Software
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software
SET "STRTMP=HKCU_SW"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_SOFTWARE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKCU\Software\Wow6432Node
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node
SET "STRTMP=HKCU_SW(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Wow6432Node" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Wow6432Node\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_SOFTWARE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKCU\Software\AppDataLow\Software
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\AppDataLow\Software
SET "STRTMP=HKCU_SW_AppDataLow_SW"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\AppDataLow\Software" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\AppDataLow\Software\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_SOFTWARE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_SOFTWARE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Active Setup\Installed Components
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Active Setup\Installed Components
SET "STRTMP=HKCU_SW_ActiveSetup_InstalledComponents"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Microsoft\Active Setup\Installed Components" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\��������\Installed Components\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_SOFTWARE_INSTCOMPONENTS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_SOFTWARE_INSTCOMPONENTS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Active Setup\Installed Components
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Active Setup\Installed Components
SET "STRTMP=HKCU_SW_ActiveSetup_InstalledComponents(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Wow6432Node\Microsoft\Active Setup\Installed Components" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Wow6432Node\��������\Installed Components\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_SOFTWARE_INSTCOMPONENTS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_SOFTWARE_INSTCOMPONENTS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Internet Explorer (DownloadUI)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer
SET "STRTMP=HKCU_SW_InternetExplorer_DownloadUI"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Internet Explorer\DownloadUI" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Microsoft\Internet Explorer : DownloadUI" 2>Nul
	>VARIABLE\TXT2 ECHO DownloadUI
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
)
REM :HKCU\Software\Wow6432Node\Microsoft\Internet Explorer (DownloadUI)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Internet Explorer
SET "STRTMP=HKCU_SW_InternetExplorer_DownloadUI(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\DownloadUI" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Wow6432Node\Microsoft\Internet Explorer : DownloadUI" 2>Nul
	>VARIABLE\TXT2 ECHO DownloadUI
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
)
REM :HKCU\Software\Microsoft\Internet Explorer\Approved Extensions (Value)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\Approved Extensions
SET "STRTMP=HKCU_SW_InternetExplorer_ApprovedExtensions"
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Internet Explorer\Approved Extensions" -ot reg -actn ace -ace "n:%USERNAME%;p:KEY_SET_VALUE;m:revoke;i:so" -ace "n:%USERNAME%;p:KEY_SET_VALUE;i:so" -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Microsoft\Internet Explorer\Approved Extensions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\��������\Approved Extensions : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Internet Explorer\Approved Extensions" -ot reg -actn ace -ace "n:%USERNAME%;p:KEY_SET_VALUE;m:revoke;i:so" -ace "n:%USERNAME%;p:KEY_SET_VALUE;m:deny;i:so" -silent >Nul 2>Nul
REM :HKCU\Software\Microsoft\Internet Explorer\ApprovedExtensionsMigration
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\ApprovedExtensionsMigration
SET "STRTMP=HKCU_SW_InternetExplorer_ApprovedExtensionsMigration"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Microsoft\Internet Explorer\ApprovedExtensionsMigration" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\��������\ApprovedExtensionsMigration\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Internet Explorer\SearchScopes
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\SearchScopes
SET "STRTMP=HKCU_SW_InternetExplorer_SearchScopes"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Microsoft\Internet Explorer\SearchScopes" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\��������\SearchScopes\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_IE_SEARCHSCOPES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\SearchScopes
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\SearchScopes
SET "STRTMP=HKCU_SW_InternetExplorer_SearchScopes(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\SearchScopes" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Wow6432Node\��������\SearchScopes\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_IE_SEARCHSCOPES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Internet Explorer\Toolbar (Value)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\Toolbar
SET "STRTMP=HKCU_SW_InternetExplorer_Toolbar"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Microsoft\Internet Explorer\Toolbar" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\��������\Toolbar : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Toolbar (Value)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Toolbar
SET "STRTMP=HKCU_SW_InternetExplorer_Toolbar(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Toolbar" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Wow6432Node\��������\Toolbar : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Internet Explorer\Toolbar\WebBrowser (Value)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\Toolbar\WebBrowser
SET "STRTMP=HKCU_SW_InternetExplorer_Toolbar_WebBrowser"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Microsoft\Internet Explorer\Toolbar\WebBrowser" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\��������\WebBrowser : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Toolbar\WebBrowser (Value)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Toolbar\WebBrowser
SET "STRTMP=HKCU_SW_InternetExplorer_Toolbar_WebBrowser(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Toolbar\WebBrowser" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Wow6432Node\��������\WebBrowser : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Internet Explorer\URLSearchHooks (Value)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\URLSearchHooks
SET "STRTMP=HKCU_SW_InternetExplorer_URLSearchHooks"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Microsoft\Internet Explorer\URLSearchHooks" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\��������\URLSearchHooks : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\URLSearchHooks (Value)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\URLSearchHooks
SET "STRTMP=HKCU_SW_InternetExplorer_URLSearchHooks(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\URLSearchHooks" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Wow6432Node\��������\URLSearchHooks : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\App Management\ARPCache
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\App Management\ARPCache
SET "STRTMP=HKCU_SW_AppManagement_ARPCache"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Microsoft\Windows\CurrentVersion\App Management\ARPCache" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\��������\ARPCache\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HK_SOFTWARE_ARPCACHE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Management\ARPCache
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Management\ARPCache
SET "STRTMP=HKCU_SW_AppManagement_ARPCache(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Management\ARPCache" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Wow6432Node\��������\ARPCache\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HK_SOFTWARE_ARPCACHE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\App Paths
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\App Paths
SET "STRTMP=HKCU_SW_AppPaths"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Microsoft\Windows\CurrentVersion\App Paths" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\��������\App Paths\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HK_SOFTWARE_APPPATHS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Paths
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Paths
SET "STRTMP=HKCU_SW_AppPaths(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Paths" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Wow6432Node\��������\ARPCache\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HK_SOFTWARE_APPPATHS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MenuOrder\Start Menu2\Programs
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MenuOrder\Start Menu2\Programs
SET "STRTMP=HKCU_SW_Explorer_MenuOrder_StartMenu2_Programs"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MenuOrder\Start Menu2\Programs" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\��������\MenuOrder\Start Menu2\Programs\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\DIRECTORY\DEL_STARTMENU_PROGRAMS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings
SET "STRTMP=HKCU_SW_Ext_Settings"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\��������\Ext\Settings\%%A" 2>Nul
	SETLOCAL ENABLEDELAYEDEXPANSION
	TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\%%A\Flags" >Nul 2>Nul
	IF !ERRORLEVEL! NEQ 0 (
		ENDLOCAL
		>VARIABLE\TXT2 ECHO %%A
		>VARIABLE\CHCK ECHO 0
		SETLOCAL ENABLEDELAYEDEXPANSION
		<VARIABLE\CHCK SET /P CHCK=
		IF !CHCK! EQU 0 (
			ENDLOCAL
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
		) ELSE (
			ENDLOCAL
		)
		SETLOCAL ENABLEDELAYEDEXPANSION
		<VARIABLE\CHCK SET /P CHCK=
		IF !CHCK! EQU 0 (
			ENDLOCAL
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		) ELSE (
			ENDLOCAL
		)
		SETLOCAL ENABLEDELAYEDEXPANSION
		<VARIABLE\CHCK SET /P CHCK=
		IF !CHCK! EQU 0 (
			ENDLOCAL
			IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
			)
		) ELSE (
			ENDLOCAL
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Ext\Settings
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Ext\Settings
SET "STRTMP=HKCU_SW_Ext_Settings(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Ext\Settings" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Wow6432Node\��������\Ext\Settings\%%A" 2>Nul
	SETLOCAL ENABLEDELAYEDEXPANSION
	TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Ext\Settings\%%A\Flags" >Nul 2>Nul
	IF !ERRORLEVEL! NEQ 0 (
		ENDLOCAL
		>VARIABLE\TXT2 ECHO %%A
		>VARIABLE\CHCK ECHO 0
		SETLOCAL ENABLEDELAYEDEXPANSION
		<VARIABLE\CHCK SET /P CHCK=
		IF !CHCK! EQU 0 (
			ENDLOCAL
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
		) ELSE (
			ENDLOCAL
		)
		SETLOCAL ENABLEDELAYEDEXPANSION
		<VARIABLE\CHCK SET /P CHCK=
		IF !CHCK! EQU 0 (
			ENDLOCAL
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		) ELSE (
			ENDLOCAL
		)
		SETLOCAL ENABLEDELAYEDEXPANSION
		<VARIABLE\CHCK SET /P CHCK=
		IF !CHCK! EQU 0 (
			ENDLOCAL
			IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
			)
		) ELSE (
			ENDLOCAL
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats
SET "STRTMP=HKCU_SW_Ext_Stats"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\��������\Ext\Stats\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Ext\Stats
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Ext\Stats
SET "STRTMP=HKCU_SW_Ext_Stats(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Ext\Stats" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Wow6432Node\��������\Ext\Stats\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings (ProxyOverride)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings
SET "STRTMP=HKCU_SW_InternetSettings"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ProxyOverride" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\��������\Internet Settings : ProxyOverride" 2>Nul
	>VARIABLE\TXT2 ECHO ProxyOverride
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_HKCU_PROXYOVERRIDE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
)
REM :HKCU\Software (ETCs)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "TOKENS=1,2 DELIMS=|" %%A IN (DB_EXEC\REGDEL_HKCU_SOFTWARE_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		IF NOT "%%B" == "" (
			TITLE �˻���^(DB^) "HKCU\Software\%%A : %%~nxB" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\%%A\%%B" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKCU\Software\%%A
				>VARIABLE\TXT2 ECHO %%B
				CALL :DEL_REGV NULL BACKUP RANDOM "HKCU_SoftwareETCs"
			)
			TITLE �˻���^(DB^) "HKCU\Software\Wow6432Node\%%A : %%~nxB" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\%%A\%%B" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\%%A
				>VARIABLE\TXT2 ECHO %%B
				CALL :DEL_REGV NULL BACKUP RANDOM "HKCU_SoftwareETCs(x86)"
			)
		) ELSE (
			TITLE �˻���^(DB^) "HKCU\Software\%%A" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -v -q check "\HKCU\Software\%%A" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKCU\Software
				>VARIABLE\TXT2 ECHO %%A
				CALL :DEL_REGK NULL BACKUP "HKCU_SoftwareETCs"
			)
			TITLE �˻���^(DB^) "HKCU\Software\Wow6432Node\%%A" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -v -q check "\HKCU\Software\Wow6432Node\%%A" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node
				>VARIABLE\TXT2 ECHO %%A
				CALL :DEL_REGK NULL BACKUP "HKCU_SoftwareETCs(x86)"
			)
		)
	)
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Delete - Registry <HKEY_LOCAL_MACHINE>
ECHO �� �Ǽ� �� ���� ���� ^<HKEY_LOCAL_MACHINE^> ������Ʈ�� ������ . . . & >>"%QLog%" ECHO    �� �Ǽ� �� ���� ���� ^<HKEY_LOCAL_MACHINE^> ������Ʈ�� ���� :
REM :HKLM\Software
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software
SET "STRTMP=HKLM_SW"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_SOFTWARE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_SOFTWARE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node
SET "STRTMP=HKLM_SW(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Wow6432Node\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_SOFTWARE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_SOFTWARE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Classes
TITLE ���� �˻��� "HKLM\Software\Classes" / ���¿� ���� �ð��� �ҿ�� �� ���� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Classes
SET "STRTMP=HKLM_SW_Classes"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Classes" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -ivxf DB\EXCEPT\EX_REG_HK_PATTERN.DB 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Classes\APPID
TITLE ���� �˻��� "HKLM\Software\Classes\APPID" / ���¿� ���� �ð��� �ҿ�� �� ���� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Classes\APPID
SET "STRTMP=HKLM_SW_Classes_APPID"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Classes\APPID" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_APPID.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_APPID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKLM\Software\Wow6432Node\Classes\APPID
TITLE ���� �˻��� "HKLM\Software\Wow6432Node\Classes\APPID" / ���¿� ���� �ð��� �ҿ�� �� ���� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Classes\APPID
SET "STRTMP=HKLM_SW_Classes_APPID(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Classes\APPID" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_APPID.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_APPID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKLM\Software\Classes\CLSID
TITLE ���� �˻��� "HKLM\Software\Classes\CLSID" / ���¿� ���� �ð��� �ҿ�� �� ���� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Classes\CLSID
SET "STRTMP=HKLM_SW_Classes_CLSID"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Classes\CLSID" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_CLSID.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Classes\CLSID
TITLE ���� �˻��� "HKLM\Software\Wow6432Node\Classes\CLSID" / ���¿� ���� �ð��� �ҿ�� �� ���� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Classes\CLSID
SET "STRTMP=HKLM_SW_Classes_CLSID(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Classes\CLSID" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_CLSID.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Classes\Interface
TITLE ���� �˻��� "HKLM\Software\Classes\Interface" / ���¿� ���� �ð��� �ҿ�� �� ���� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Classes\Interface
SET "STRTMP=HKLM_SW_Classes_Interface"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Classes\Interface" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_INTERFACE.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_INTERFACE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_INTERFACE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Classes\Interface
TITLE ���� �˻��� "HKLM\Software\Wow6432Node\Classes\Interface" / ���¿� ���� �ð��� �ҿ�� �� ���� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Classes\Interface
SET "STRTMP=HKLM_SW_Classes_Interface(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Classes\Interface" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_INTERFACE.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_INTERFACE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_INTERFACE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Classes\TypeLib
TITLE ���� �˻��� "HKLM\Software\Classes\TypeLib" / ���¿� ���� �ð��� �ҿ�� �� ���� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Classes\TypeLib
SET "STRTMP=HKLM_SW_Classes_TypeLib"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Classes\TypeLib" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_TYPELIB.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_TYPELIB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_TYPELIB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Classes\TypeLib
TITLE ���� �˻��� "HKLM\Software\Wow6432Node\Classes\TypeLib" / ���¿� ���� �ð��� �ҿ�� �� ���� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Classes\TypeLib
SET "STRTMP=HKLM_SW_Classes_TypeLib(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Classes\TypeLib" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_TYPELIB.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_TYPELIB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_TYPELIB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Google\Chrome\Extensions
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Google\Chrome\Extensions
SET "STRTMP=HKLM_SW_GoogleChrome_Extensions"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Google\Chrome\Extensions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Google\Chrome\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Google\Chrome\Extensions
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Google\Chrome\Extensions
SET "STRTMP=HKLM_SW_GoogleChrome_Extensions(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Google\Chrome\Extensions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Wow6432Node\Google\Chrome\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Active Setup\Installed Components
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Active Setup\Installed Components
SET "STRTMP=HKLM_SW_ActiveSetup_InstalledComponents"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Active Setup\Installed Components" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\��������\Installed Components\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_SOFTWARE_INSTCOMPONENTS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_SOFTWARE_INSTCOMPONENTS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Active Setup\Installed Components
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Active Setup\Installed Components
SET "STRTMP=HKLM_SW_ActiveSetup_InstalledComponents(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Active Setup\Installed Components" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Wow6432Node\��������\Installed Components\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_SOFTWARE_INSTCOMPONENTS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_SOFTWARE_INSTCOMPONENTS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Internet Explorer\ApprovedExtensionsMigration
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Internet Explorer\ApprovedExtensionsMigration
SET "STRTMP=HKLM_SW_InternetExplorer_ApprovedExtensionsMigration"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Internet Explorer\ApprovedExtensionsMigration" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\��������\ApprovedExtensionsMigration\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Internet Explorer\Low Rights\ElevationPolicy
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Internet Explorer\Low Rights\ElevationPolicy
SET "STRTMP=HKLM_SW_InternetExplorer_LowRights_ElevationPolicy"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Internet Explorer\Low Rights\ElevationPolicy" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\��������\Low Rights\ElevationPolicy\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Low Rights\ElevationPolicy
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Low Rights\ElevationPolicy
SET "STRTMP=HKLM_SW_InternetExplorer_LowRights_ElevationPolicy(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Low Rights\ElevationPolicy" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Wow6432Node\��������\Low Rights\ElevationPolicy\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Internet Explorer\SearchScopes
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Internet Explorer\SearchScopes
SET "STRTMP=HKLM_SW_InternetExplorer_SearchScopes"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Internet Explorer\SearchScopes" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\��������\SearchScopes\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_IE_SEARCHSCOPES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\SearchScopes
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\SearchScopes
SET "STRTMP=HKLM_SW_InternetExplorer_SearchScopes(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\SearchScopes" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\��������\SearchScopes\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_IE_SEARCHSCOPES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Internet Explorer\Toolbar (Value)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Internet Explorer\Toolbar
SET "STRTMP=HKLM_SW_InternetExplorer_Toolbar"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Microsoft\Internet Explorer\Toolbar" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\��������\Toolbar : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Toolbar (Value)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Toolbar
SET "STRTMP=HKLM_SW_InternetExplorer_Toolbar(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Toolbar" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Wow6432Node\��������\Toolbar : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Tracing
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Tracing
SET "STRTMP=HKLM_SW_Tracing"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Tracing" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Microsoft\Tracing\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HKLM_SOFTWARE_TRACING.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKLM\Software\Wow6432Node\Microsoft\Tracing
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Tracing
SET "STRTMP=HKLM_SW_Tracing(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Tracing" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Wow6432Node\Microsoft\Tracing\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HKLM_SOFTWARE_TRACING.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\App Management\ARPCache
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\App Management\ARPCache
SET "STRTMP=HKLM_SW_AppManagement_ARPCache"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\App Management\ARPCache" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\��������\App Management\ARPCache\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HK_SOFTWARE_ARPCACHE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Management\ARPCache
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Management\ARPCache
SET "STRTMP=HKLM_SW_AppManagement_ARPCache(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Management\ARPCache" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Wow6432Node\��������\App Management\ARPCache\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HK_SOFTWARE_ARPCACHE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\App Paths
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\App Paths
SET "STRTMP=HKLM_SW_AppPaths"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\App Paths" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\��������\App Paths\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HK_SOFTWARE_APPPATHS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Paths
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Paths
SET "STRTMP=HKLM_SW_AppPaths(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Paths" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Wow6432Node\��������\App Paths\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HK_SOFTWARE_APPPATHS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\ShellExecuteHooks (Value)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\ShellExecuteHooks
SET "STRTMP=HKLM_SW_ShellExecuteHooks"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\ShellExecuteHooks" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\��������\Explorer\ShellExecuteHooks : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\ShellExecuteHooks (Value)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\ShellExecuteHooks
SET "STRTMP=HKLM_SW_ShellExecuteHooks(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\ShellExecuteHooks" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Wow6432Node\��������\Explorer\ShellExecuteHooks : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Ext\PreApproved
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Ext\PreApproved
SET "STRTMP=HKLM_SW_Ext_PreApproved"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\Ext\PreApproved" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\��������\Ext\PreApproved\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Ext\PreApproved
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Ext\PreApproved
SET "STRTMP=HKLM_SW_Ext_PreApproved(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Ext\PreApproved" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Wow6432Node\��������\Ext\PreApproved\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Ext\CLSID (Value)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Ext\CLSID
SET "STRTMP=HKLM_SW_Policies_Ext_CLSID"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Ext\CLSID" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\��������\Policies\Ext\CLSID : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Ext\CLSID (Value)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Ext\CLSID
SET "STRTMP=HKLM_SW_Policies_Ext_CLSID(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Ext\CLSID" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Wow6432Node\��������\Policies\Ext\CLSID : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options (Debugger)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
SET "STRTMP=HKLM_SW_ImageFileExecutionOptions"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%A" == "YOUR IMAGE FILE NAME HERE WITHOUT A PATH" (
		TITLE �˻��� "HKLM\Software\��������\Image File Execution Options\%%A" 2>Nul
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%A
		>VARIABLE\TXT2 ECHO Debugger
		>VARIABLE\TXTX ECHO %%A
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HKLM_SOFTWARE_IMGFILEEXECOP.DB VARIABLE\TXTX 2^>Nul') DO (
			FOR /F "DELIMS=" %%Y IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%A\Debugger" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
				IF EXIST "DB\EXCEPT\DEBUGGER_%%A.DB" (
					>VARIABLE\TXTX ECHO %%~nxY
					FOR /F %%Z IN ('TOOLS\GREP\GREP.EXE -Fixvf "DB\EXCEPT\DEBUGGER_%%A.DB" VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV NULL BACKUP RANDOM "%STRTMP%"
				) ELSE (
					CALL :DEL_REGV NULL BACKUP RANDOM "%STRTMP%"
				)
			)
		)
		FOR /F "DELIMS=" %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%A\Debugger" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			>VARIABLE\TXTX ECHO %%~nxX
			FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HKLM_SOFTWARE_IMGFILEEXECOP.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP RANDOM "%STRTMP%"
		)
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options (Debugger)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
SET "STRTMP=HKLM_SW_ImageFileExecutionOptions(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%A" == "YOUR IMAGE FILE NAME HERE WITHOUT A PATH" (
		TITLE �˻��� "HKLM\Software\Wow6432Node\��������\Image File Execution Options\%%A" 2>Nul
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%A
		>VARIABLE\TXT2 ECHO Debugger
		>VARIABLE\TXTX ECHO %%A
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HKLM_SOFTWARE_IMGFILEEXECOP.DB VARIABLE\TXTX 2^>Nul') DO (
			FOR /F "DELIMS=" %%Y IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%A\Debugger" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
				IF EXIST "DB\EXCEPT\DEBUGGER_%%A.DB" (
					>VARIABLE\TXTX ECHO %%~nxY
					FOR /F %%Z IN ('TOOLS\GREP\GREP.EXE -Fixvf "DB\EXCEPT\DEBUGGER_%%A.DB" VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV NULL BACKUP RANDOM "%STRTMP%"
				) ELSE (
					CALL :DEL_REGV NULL BACKUP RANDOM "%STRTMP%"
				)
			)
		)
		FOR /F "DELIMS=" %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%A\Debugger" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			>VARIABLE\TXTX ECHO %%~nxX
			FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HKLM_SOFTWARE_IMGFILEEXECOP.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP RANDOM "%STRTMP%"
		)
	)
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures (Value)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures
SET "STRTMP=HKLM_SW_Schedule_CompatibilityAdapter_Signatures"
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures" -ot reg -actn ace -ace "n:Everyone;p:full" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\��������\Schedule\CompatibilityAdapter\Signatures : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_TASKS_JOB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_TASKS_JOB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_REG_TASKS_JOB.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fxf DB_ACTIVE\ACT_REG_TASKS_JOB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures" -ot reg -actn trustee -trst "n1:Everyone;ta:remtrst;w:dacl" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures" -ot reg -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
REM :HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures (Value)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures
SET "STRTMP=HKLM_SW_Schedule_CompatibilityAdapter_Signatures(x86)"
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures" -ot reg -actn ace -ace "n:Everyone;p:full" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Wow6432Node\��������\Schedule\CompatibilityAdapter\Signatures : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_TASKS_JOB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_TASKS_JOB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_REG_TASKS_JOB.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fxf DB_ACTIVE\ACT_REG_TASKS_JOB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures" -ot reg -actn trustee -trst "n1:Everyone;ta:remtrst;w:dacl" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures" -ot reg -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree
SET "STRTMP=HKLM_SW_Schedule_TaskCache_Tree"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\��������\Schedule\TaskCache\Tree\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F "DELIMS=" %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\%%A\Id" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_TASKS_TREE.DB VARIABLE\TXT2 2^>Nul') DO (
				>>DB_ACTIVE\ACT_REG_TASKS_CLSID.DB ECHO %%X
				CALL :DEL_REGK NULL BACKUP "%STRTMP%"
			)
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_REG_TASKS_TREE.DB" (
			FOR /F "DELIMS=" %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\%%A\Id" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
				FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fxf DB_ACTIVE\ACT_REG_TASKS_TREE.DB VARIABLE\TXT2 2^>Nul') DO (
					>>DB_ACTIVE\ACT_REG_TASKS_CLSID.DB ECHO %%X
					CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
				)
			)
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree
SET "STRTMP=HKLM_SW_Schedule_TaskCache_Tree(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Wow6432Node\��������\Schedule\TaskCache\Tree\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F "DELIMS=" %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\%%A\Id" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_TASKS_TREE.DB VARIABLE\TXT2 2^>Nul') DO (
				>>DB_ACTIVE\ACT_REG_TASKS_CLSID.DB ECHO %%X
				CALL :DEL_REGK NULL BACKUP "%STRTMP%"
			)
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_REG_TASKS_TREE.DB" (
			FOR /F "DELIMS=" %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\%%A\Id" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
				FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fxf DB_ACTIVE\ACT_REG_TASKS_TREE.DB VARIABLE\TXT2 2^>Nul') DO (
					>>DB_ACTIVE\ACT_REG_TASKS_CLSID.DB ECHO %%X
					CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
				)
			)
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Svchost (Value)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Svchost
SET "STRTMP=HKLM_SW_Svchost"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Svchost" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\��������\Svchost : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HKLM_SVCHOST.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Svchost (Value)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Svchost
SET "STRTMP=HKLM_SW_Svchost(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Svchost" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Wow6432Node\��������\Svchost : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HKLM_SVCHOST.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain
SET "STRTMP=HKLM_SW_Schedule_TaskCache_Plain"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\��������\Schedule\TaskCache\Plain\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "DB_ACTIVE\ACT_REG_TASKS_CLSID.DB" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_REG_TASKS_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain
SET "STRTMP=HKLM_SW_Schedule_TaskCache_Plain(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Wow6432Node\��������\Schedule\TaskCache\Plain\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "DB_ACTIVE\ACT_REG_TASKS_CLSID.DB" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_REG_TASKS_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	)
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks
SET "STRTMP=HKLM_SW_Schedule_TaskCache_Tasks"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\��������\Schedule\TaskCache\Tasks\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "DB_ACTIVE\ACT_REG_TASKS_CLSID.DB" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_REG_TASKS_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks
SET "STRTMP=HKLM_SW_Schedule_TaskCache_Tasks(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Wow6432Node\��������\Schedule\TaskCache\Tasks\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "DB_ACTIVE\ACT_REG_TASKS_CLSID.DB" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_REG_TASKS_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	)
)
REM :HKLM\Software\Mozilla\Firefox\Extensions
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Mozilla\Firefox\Extensions
SET "STRTMP=HKLM_Mozilla_Firefox_Extensions"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Mozilla\Firefox\Extensions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Mozilla\Firefox\Extensions : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_FIREFOX.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_BROWSER_EXTENSIONS_FIREFOX.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Mozilla\Firefox\Extensions
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Mozilla\Firefox\Extensions
SET "STRTMP=HKLM_Mozilla_Firefox_Extensions(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Wow6432Node\Mozilla\Firefox\Extensions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Mozilla\Firefox\Extensions : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_FIREFOX.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_BROWSER_EXTENSIONS_FIREFOX.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Policies\Microsoft\Windows\IPSec\Policy\Local
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Policies\Microsoft\Windows\IPSec\Policy\Local
SET "STRTMP=HKLM_SW_Policies_IPSecLocal"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Policies\Microsoft\Windows\IPSec\Policy\Local" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Policies\��������\IPSec\Policy\Local\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "DELIMS=" %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Policies\Microsoft\Windows\IPSec\Policy\Local\%%A\ipsecName" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
		>VARIABLE\TXTX ECHO %%X
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fxf DB_EXEC\THREAT\REGISTRY\DEL_IPSEC_POLICY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	)
)
REM :HKLM\Software (ETCs)
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "TOKENS=1,2 DELIMS=|" %%A IN (DB_EXEC\REGDEL_HKLM_SOFTWARE_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		IF NOT "%%B" == "" (
			TITLE �˻���^(DB^) "HKLM\Software\%%A : %%~nxB" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\%%A\%%B" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKLM\Software\%%A
				>VARIABLE\TXT2 ECHO %%B
				CALL :DEL_REGV NULL BACKUP RANDOM "HKLM_SoftwareETCs"
			)
			TITLE �˻���^(DB^) "HKLM\Software\Wow6432Node\%%A : %%~nxB" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\%%A\%%B" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\%%A
				>VARIABLE\TXT2 ECHO %%B
				CALL :DEL_REGV NULL BACKUP RANDOM "HKLM_SoftwareETCs(x86)"
			)
		) ELSE (
			TITLE �˻���^(DB^) "HKLM\Software\%%A" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -v -q check "\HKLM\Software\%%A" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKLM\Software
				>VARIABLE\TXT2 ECHO %%A
				CALL :DEL_REGK NULL BACKUP "HKLM_SoftwareETCs"
			)
			TITLE �˻���^(DB^) "HKLM\Software\Wow6432Node\%%A" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -v -q check "\HKLM\Software\Wow6432Node\%%A" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node
				>VARIABLE\TXT2 ECHO %%A
				CALL :DEL_REGK NULL BACKUP "HKLM_SoftwareETCs(x86)"
			)
		)
	)
)
REM :HKLM\System\CurrentControlSet\Services\EventLog\Application
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\EventLog\Application
SET "STRTMP=HKLM_ServicesEventLogApplication"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\System\CurrentControlSet\Services\EventLog\Application" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\System\CurrentControlSet\Services\EventLog\Application\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_EVENTLOG_APPLICATION.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKLM\System\CurrentControlSet
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "TOKENS=1,2 DELIMS=|" %%A IN (DB_EXEC\REGDEL_HKLM_SYSTEM.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		IF NOT "%%B" == "" (
			TITLE �˻���^(DB^) "HKLM\System\CurrentControlSet\%%A : %%B" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\%%A\%%B" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\%%A
				>VARIABLE\TXT2 ECHO %%B
				CALL :DEL_REGV NULL BACKUP RANDOM "HKLM_SystemCurrentControlSet"
			)
		) ELSE (
			TITLE �˻���^(DB^) "HKLM\System\CurrentControlSet\%%A" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -v -q check "\HKLM\System\CurrentControlSet\%%A" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet
				>VARIABLE\TXT2 ECHO %%A
				CALL :DEL_REGK NULL BACKUP "HKLM_SystemCurrentControlSet"
			)
		)
	)
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Delete - Registry <Malicious BHO(Browser Helper Object)>
ECHO �� �Ǽ� �� ���� ���� BHO^(Browser Helper Object^) ������ . . . & >>"%QLog%" ECHO    �� �Ǽ� �� ���� ���� BHO^(Browser Helper Object^) ���� :
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects
SET "STRTMP=HKLM_BrowserHelperObjects"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "Browser Helper Objects : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		CALL :GET_DVAL
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fxf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID_DEFAULTVAL.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		CALL :GET_DVAL
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects
SET "STRTMP=HKLM_BrowserHelperObjects(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "Browser Helper Objects (x64) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		CALL :GET_DVAL
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fxf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID_DEFAULTVAL.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		CALL :GET_DVAL
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Delete - Registry <Malicious Firewall Rules>
ECHO �� �Ǽ� �� ���� ���� ��ȭ�� ��Ģ ������ . . . & >>"%QLog%" ECHO    �� �Ǽ� �� ���� ���� ��ȭ�� ��Ģ ���� :
REM :HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules
SET "STRTMP=HKLM_FirewallPolicy_FirewallRules"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Eix "\{[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}\}" 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Ei "\|Action=Allow\|" 2^>Nul') DO (
		TITLE �˻��� "HKLM\System\��������\FirewallPolicy\FirewallRules : %%A" 2>Nul
		>VARIABLE\TXT2 ECHO %%A
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Ff DB_EXEC\THREAT\NETWORK\DEL_BAD_FIREWALL_RULES.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	)
)
REM :HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\AuthorizedApplications\List
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\AuthorizedApplications\List
SET "STRTMP=HKLM_FirewallPolicy_AuthorizedApplications_List"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\AuthorizedApplications\List" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\AuthorizedApplications\List\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
		TITLE �˻��� "HKLM\System\��������\AuthorizedApplications\List : %%A" 2>Nul
		>VARIABLE\TXT2 ECHO %%A
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Ff DB_EXEC\THREAT\NETWORK\DEL_BAD_FIREWALL_AUTHORIZEDAPPLICATIONS_RULES.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	)
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Delete - Malicious Background Intelligent Transfer Service Job
ECHO �� �Ǽ� �� ���� ���� ���� ���� ���� �۾� ������ . . . & >>"%QLog%" ECHO    �� �Ǽ� �� ���� ���� ���� ���� ���� �۾� ���� :
TITLE ^(Ȯ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "TOKENS=1,*" %%A IN ('BITSADMIN.EXE /LIST /ALLUSERS 2^>Nul^|TOOLS\GREP\GREP.EXE -Ei "\{[0-9A-Z]{8}-[0-9A-Z]{4}-[0-9A-Z]{4}-[0-9A-Z]{4}-[0-9A-Z]{12}\}" 2^>Nul') DO (
	TITLE �˻��� "BITS Job : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%B
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fif DB_EXEC\THREAT\SERVICE\DEL_BITSADMIN_JOB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_BITS NULL "%%A"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\SERVICE\PATTERN_BITSADMIN_JOB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_BITS ACTIVESCAN "%%A"
	) ELSE (
		ENDLOCAL
	)
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Delete - Registry <Malicious Browser Extensions>
ECHO �� �Ǽ� �� ���� ���� ������ Ȯ�� ��� ������ . . . & >>"%QLog%" ECHO    �� �Ǽ� �� ���� ���� ������ Ȯ�� ��� ���� :
REM :HKCU\Software\Microsoft\Internet Explorer\Extensions
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\Extensions
SET "STRTMP=HKCU_InternetExplorerExtensions"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Microsoft\Internet Explorer\Extensions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Microsoft\Internet Explorer\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -v -q check "\HKCU\Software\Microsoft\Internet Explorer\Extensions\%%A" 2^>Nul') DO (
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_BROWSER_EXTENSIONS_IE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Extensions
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Extensions
SET "STRTMP=HKCU_InternetExplorerExtensions(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Extensions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -v -q check "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Extensions\%%A" 2^>Nul') DO (
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_BROWSER_EXTENSIONS_IE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	)
)
REM :HKLM\Software\Microsoft\Internet Explorer\Extensions
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Internet Explorer\Extensions
SET "STRTMP=HKLM_InternetExplorerExtensions"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Internet Explorer\Extensions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Microsoft\Internet Explorer\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -v -q check "\HKLM\Software\Microsoft\Internet Explorer\Extensions\%%A" 2^>Nul') DO (
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_BROWSER_EXTENSIONS_IE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Extensions
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Extensions
SET "STRTMP=HKLM_InternetExplorerExtensions(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Extensions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -v -q check "\HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Extensions\%%A" 2^>Nul') DO (
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_BROWSER_EXTENSIONS_IE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	)
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Reset Internet Explorer Start & Search Page
ECHO �� �� ������ - ���ͳ� �ͽ��÷η� �Ǽ� ���� �� �˻� ������ ������ . . . & >>"%QLog%" ECHO    �� �� ������ - ���ͳ� �ͽ��÷η� �Ǽ� ���� �� �˻� ������ ���� :
REM :HKCU\Software\Microsoft\Internet Explorer\Main (Default_Page_URL)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Internet Explorer\Main\Default_Page_URL" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Microsoft\Internet Explorer\Main : Default_Page_URL" 2>Nul
	>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Default_Page_URL
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKCU_InternetExplorer_DefaultPageURL"
		REG.EXE ADD "HKCU\Software\Microsoft\Internet Explorer\Main" /v "Default_Page_URL" /d "http://www.msn.com" /f >Nul 2>Nul
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main (Default_Page_URL)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main\Default_Page_URL" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main : Default_Page_URL" 2>Nul
	>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Default_Page_URL
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKCU_InternetExplorer_DefaultPageURL(x86)"
		REG.EXE ADD "HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main" /v "Default_Page_URL" /d "http://www.msn.com" /f >Nul 2>Nul
	)
)
REM :HKCU\Software\Microsoft\Internet Explorer\Main (Default_Search_URL)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Internet Explorer\Main\Default_Search_URL" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Microsoft\Internet Explorer\Main : Default_Search_URL" 2>Nul
	>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Default_Search_URL
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKCU_InternetExplorer_DefaultSearchURL"
		REG.EXE ADD "HKCU\Software\Microsoft\Internet Explorer\Main" /v "Default_Search_URL" /d "http://www.bing.com" /f >Nul 2>Nul
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main (Default_Search_URL)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main\Default_Search_URL" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main : Default_Search_URL" 2>Nul
	>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Default_Search_URL
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKCU_InternetExplorer_DefaultSearchURL(x86)"
		REG.EXE ADD "HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main" /v "Default_Search_URL" /d "http://www.bing.com" /f >Nul 2>Nul
	)
)
REM :HKCU\Software\Microsoft\Internet Explorer\Main (Start Page)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Internet Explorer\Main\Start Page" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Microsoft\Internet Explorer\Main : Start Page" 2>Nul
	>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Start Page
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKCU_InternetExplorer_StartPage"
		REG.EXE ADD "HKCU\Software\Microsoft\Internet Explorer\Main" /v "Start Page" /d "http://cyberbureau.police.go.kr/prevention/prevention1.jsp?mid=020301" /f >Nul 2>Nul
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main (Start Page)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main\Start Page" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main : Start Page" 2>Nul
	>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Start Page
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKCU_InternetExplorer_StartPage(x86)"
		REG.EXE ADD "HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main" /v "Start Page" /d "http://cyberbureau.police.go.kr/prevention/prevention1.jsp?mid=020301" /f >Nul 2>Nul
	)
)
REM :HKCU\Software\Microsoft\Internet Explorer\Main (Secondary Start Pages)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Internet Explorer\Main\Secondary Start Pages" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Microsoft\Internet Explorer\Main : Secondary Start Pages" 2>Nul
	>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Secondary Start Pages
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKCU_InternetExplorer_SecondaryStartPages"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main (Secondary Start Pages)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main\Secondary Start Pages" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main : Secondary Start Pages" 2>Nul
	>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Secondary Start Pages
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKCU_InternetExplorer_SecondaryStartPages(x86)"
	)
)
REM :HKCU\Software\Microsoft\Internet Explorer\Main (Search Page)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Internet Explorer\Main\Search Page" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Microsoft\Internet Explorer\Main : Search Page" 2>Nul
	>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Search Page
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKCU_InternetExplorer_SearchPage"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main (Search Page)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main\Search Page" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main : Search Page" 2>Nul
	>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Search Page
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKCU_InternetExplorer_SearchPage(x86)"
	)
)
REM :HKLM\Software\Microsoft\Internet Explorer\Main (Default_Page_URL)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Internet Explorer\Main\Default_Page_URL" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Microsoft\Internet Explorer\Main : Default_Page_URL" 2>Nul
	>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Default_Page_URL
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKLM_InternetExplorer_DefaultPageURL"
		REG.EXE ADD "HKLM\Software\Microsoft\Internet Explorer\Main" /v "Default_Page_URL" /d "http://www.msn.com" /f >Nul 2>Nul
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main (Default_Page_URL)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main\Default_Page_URL" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main : Default_Page_URL" 2>Nul
	>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Default_Page_URL
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKLM_InternetExplorer_DefaultPageURL(x86)"
		REG.EXE ADD "HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main" /v "Default_Page_URL" /d "http://www.msn.com" /f >Nul 2>Nul
	)
)
REM :HKLM\Software\Microsoft\Internet Explorer\Main (Default_Search_URL)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Internet Explorer\Main\Default_Search_URL" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Microsoft\Internet Explorer\Main : Default_Search_URL" 2>Nul
	>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Default_Search_URL
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKLM_InternetExplorer_DefaultSearchURL"
		REG.EXE ADD "HKLM\Software\Microsoft\Internet Explorer\Main" /v "Default_Search_URL" /d "http://www.bing.com" /f >Nul 2>Nul
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main (Default_Search_URL)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main\Default_Search_URL" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main : Default_Search_URL" 2>Nul
	>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Default_Search_URL
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKLM_InternetExplorer_DefaultSearchURL(x86)"
		REG.EXE ADD "HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main" /v "Default_Search_URL" /d "http://www.bing.com" /f >Nul 2>Nul
	)
)
REM :HKLM\Software\Microsoft\Internet Explorer\Main (Start Page)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Internet Explorer\Main\Start Page" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Microsoft\Internet Explorer\Main : Start Page" 2>Nul
	>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Start Page
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKLM_InternetExplorer_StartPage"
		REG.EXE ADD "HKLM\Software\Microsoft\Internet Explorer\Main" /v "Start Page" /d "http://cyberbureau.police.go.kr/prevention/prevention1.jsp?mid=020301" /f >Nul 2>Nul
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main (Start Page)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main\Start Page" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main : Start Page" 2>Nul
	>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Start Page
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKLM_InternetExplorer_StartPage(x86)"
		REG.EXE ADD "HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main" /v "Start Page" /d "http://cyberbureau.police.go.kr/prevention/prevention1.jsp?mid=020301" /f >Nul 2>Nul
	)
)
REM :HKLM\Software\Microsoft\Internet Explorer\Main (Search Page)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Internet Explorer\Main\Search Page" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Microsoft\Internet Explorer\Main : Search Page" 2>Nul
	>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Search Page
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKLM_InternetExplorer_SearchPage"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main (Search Page)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main\Search Page" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main : Search Page" 2>Nul
	>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Search Page
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKLM_InternetExplorer_SearchPage(x86)"
	)
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Reset Mozilla Firefox Start & Search Page
ECHO �� �� ������ - ������ ���̾����� �Ǽ� ���� �� �˻� ������ ������ . . . & >>"%QLog%" ECHO    �� �� ������ - �Ǽ� ������ ���̾����� �Ǽ� ���� �� �˻� ������ ���� :
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%APPDATA%\Mozilla\Firefox\Profiles\" 2^>Nul') DO (
	SET "STRTMP=%%A"
	IF EXIST "%APPDATA%\Mozilla\Firefox\Profiles\%%A\prefs.js" (
		TITLE �˻��� "%APPDATA%\Mozilla\Firefox\Profiles\%%A\prefs.js" 2>Nul
		>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Mozilla\Firefox\Profiles\%%A\
		>VARIABLE\TXT2 ECHO prefs.js
		SETLOCAL ENABLEDELAYEDEXPANSION
		TOOLS\ICONV\ICONV.EXE -f CP949 "!APPDATA!\Mozilla\Firefox\Profiles\!STRTMP!\prefs.js">"!TEMP!\prefs.js" 2>Nul
		IF !ERRORLEVEL! EQU 0 (
			ENDLOCAL
			IF EXIST "%TEMP%\prefs.js.clone" DEL /A /F /Q "%TEMP%\prefs.js.clone" >Nul 2>Nul
			FOR /F "DELIMS=" %%B IN ('TOOLS\ICONV\ICONV.EXE "%TEMP%\prefs.js" 2^>Nul') DO (
				>VARIABLE\TXTX ECHO %%B
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixvf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO >>"%TEMP%\prefs.js.clone" ECHO %%B
			)
			IF EXIST "%TEMP%\prefs.js" (
				IF EXIST "%TEMP%\prefs.js.clone" (
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixcf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB "%APPDATA%\Mozilla\Firefox\Profiles\%%A\prefs.js" 2^>Nul') DO (
						IF %%X NEQ 0 CALL :DEL_FILE
					)
					IF NOT EXIST "%APPDATA%\Mozilla\Firefox\Profiles\%%A\prefs.js" (
						TOOLS\ICONV\ICONV.EXE -f CP949 "%TEMP%\prefs.js.clone">"%APPDATA%\Mozilla\Firefox\Profiles\%%A\prefs.js" 2>Nul
					)
				)
			)
		) ELSE (
			ENDLOCAL
		)
	)
	IF EXIST "%APPDATA%\Mozilla\Firefox\Profiles\%%A\user.js" (
		TITLE �˻��� "%APPDATA%\Mozilla\Firefox\Profiles\%%A\user.js" 2>Nul
		>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Mozilla\Firefox\Profiles\%%A\
		>VARIABLE\TXT2 ECHO user.js
		SETLOCAL ENABLEDELAYEDEXPANSION
		TOOLS\ICONV\ICONV.EXE -f CP949 "!APPDATA!\Mozilla\Firefox\Profiles\!STRTMP!\user.js">"!TEMP!\user.js" 2>Nul
		IF !ERRORLEVEL! EQU 0 (
			ENDLOCAL
			IF EXIST "%TEMP%\user.js.clone" DEL /A /F /Q "%TEMP%\user.js.clone" >Nul 2>Nul
			FOR /F "DELIMS=" %%B IN ('TOOLS\ICONV\ICONV.EXE "%TEMP%\user.js" 2^>Nul') DO (
				>VARIABLE\TXTX ECHO %%B
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixvf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO >>"%TEMP%\user.js.clone" ECHO %%B
			)
			IF EXIST "%TEMP%\user.js" (
				IF EXIST "%TEMP%\user.js.clone" (
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixcf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB "%APPDATA%\Mozilla\Firefox\Profiles\%%A\user.js" 2^>Nul') DO (
						IF %%X NEQ 0 CALL :DEL_FILE
					)
					IF NOT EXIST "%APPDATA%\Mozilla\Firefox\Profiles\%%A\user.js" (
						TOOLS\ICONV\ICONV.EXE -f CP949 "%TEMP%\user.js.clone">"%APPDATA%\Mozilla\Firefox\Profiles\%%A\user.js" 2>Nul
					)
				)
			)
		) ELSE (
			ENDLOCAL
		)
	)
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Reset Internet Browser Shortcut Value
ECHO �� �ʱ�ȭ ��� �� ������ �ٷ� ���� Ȯ���� . . . & >>"%QLog%" ECHO    �� �ʱ�ȭ ��� �� ������ �ٷ� ���� Ȯ�� :
REM :[%SYSTEMROOT%]\System32\Config\SystemProfile\Desktop
TITLE ^(Ȯ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\Config\SystemProfile\Desktop\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\System32\Config\SystemProfile\Desktop\*.LNK" 2^>Nul') DO (
	TITLE Ȯ���� "%SYSTEMROOT%\System32\Config\SystemProfile\Desktop\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%SYSTEMROOT%\System32\Config\SystemProfile\Desktop\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%SYSTEMROOT%]\SysWOW64\Config\SystemProfile\Desktop
TITLE ^(Ȯ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\Config\SystemProfile\Desktop\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\Desktop\*.LNK" 2^>Nul') DO (
	TITLE Ȯ���� "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\Desktop\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%SYSTEMROOT%\SysWOW64\Config\SystemProfile\Desktop\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%PUBLIC%]\Desktop
TITLE ^(Ȯ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKPUBLIC%\Desktop\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%PUBLIC%\Desktop\*.LNK" 2^>Nul') DO (
	TITLE Ȯ���� "%PUBLIC%\Desktop\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%PUBLIC%\Desktop\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%USERPROFILE%]\Desktop
TITLE ^(Ȯ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKUSERPROFILE%\Desktop\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%USERPROFILE%\Desktop\*.LNK" 2^>Nul') DO (
	TITLE Ȯ���� "%USERPROFILE%\Desktop\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%USERPROFILE%\Desktop\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%ALLUSERSPROFILE%]\Microsoft\Internet Explorer\Quick Launch
TITLE ^(Ȯ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Microsoft\Internet Explorer\Quick Launch\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\Microsoft\Internet Explorer\Quick Launch\*.LNK" 2^>Nul') DO (
	TITLE Ȯ���� "%ALLUSERSPROFILE%\Microsoft\Internet Explorer\Quick Launch\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%ALLUSERSPROFILE%\Microsoft\Internet Explorer\Quick Launch\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%APPDATA%]\Microsoft\Internet Explorer\Quick Launch
TITLE ^(Ȯ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Microsoft\Internet Explorer\Quick Launch\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\*.LNK" 2^>Nul') DO (
	TITLE Ȯ���� "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%APPDATA%\Microsoft\Internet Explorer\Quick Launch\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%ALLUSERSPROFILE%]\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar
TITLE ^(Ȯ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*.LNK" 2^>Nul') DO (
	TITLE Ȯ���� "%ALLUSERSPROFILE%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%ALLUSERSPROFILE%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%APPDATA%]\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar
TITLE ^(Ȯ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*.LNK" 2^>Nul') DO (
	TITLE Ȯ���� "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%APPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%ALLUSERSPROFILE%]\Microsoft\Windows\Start Menu
TITLE ^(Ȯ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Microsoft\Windows\Start Menu\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\*.LNK" 2^>Nul') DO (
	TITLE Ȯ���� "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%APPDATA%]\Microsoft\Windows\Start Menu
TITLE ^(Ȯ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Microsoft\Windows\Start Menu\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%APPDATA%\Microsoft\Windows\Start Menu\*.LNK" 2^>Nul') DO (
	TITLE Ȯ���� "%APPDATA%\Microsoft\Windows\Start Menu\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%APPDATA%\Microsoft\Windows\Start Menu\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%ALLUSERSPROFILE%]\Microsoft\Windows\Start Menu\Programs
TITLE ^(Ȯ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\*.LNK" 2^>Nul') DO (
	TITLE Ȯ���� "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%APPDATA%]\Microsoft\Windows\Start Menu\Programs
TITLE ^(Ȯ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Microsoft\Windows\Start Menu\Programs\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%APPDATA%\Microsoft\Windows\Start Menu\Programs\*.LNK" 2^>Nul') DO (
	TITLE Ȯ���� "%APPDATA%\Microsoft\Windows\Start Menu\Programs\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%APPDATA%\Microsoft\Windows\Start Menu\Programs\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%ALLUSERSPROFILE%]\Microsoft\Windows\Start Menu\Programs // Google Chrome
TITLE ^(Ȯ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Chrome\
FOR /F "TOKENS=1,* DELIMS==" %%A IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Chrome\Chrome.lnk" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
	IF NOT "%%B" == "" (
		TITLE Ȯ���� "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Chrome\Chrome.lnk" 2>Nul
		>VARIABLE\TXT2 ECHO Chrome.lnk
		FOR /F %%X IN ('ECHO "%%B"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
	)
)
REM :[%APPDATA%]\Microsoft\Windows\Start Menu\Programs // Google Chrome
TITLE ^(Ȯ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Microsoft\Windows\Start Menu\Programs\Chrome\
FOR /F "TOKENS=1,* DELIMS==" %%A IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%APPDATA%\Microsoft\Windows\Start Menu\Programs\Chrome\Chrome.lnk" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
	IF NOT "%%B" == "" (
		TITLE Ȯ���� "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Chrome\Chrome.lnk" 2>Nul
		>VARIABLE\TXT2 ECHO Chrome.lnk
		FOR /F %%X IN ('ECHO "%%B"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
	)
)
REM :[%APPDATA%]\Microsoft\Windows\Start Menu\Programs\Accessories\System Tools
TITLE ^(Ȯ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Microsoft\Windows\Start Menu\Programs\Accessories\System Tools\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Accessories\System Tools\*.LNK" 2^>Nul') DO (
	TITLE Ȯ���� "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Accessories\System Tools\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%APPDATA%\Microsoft\Windows\Start Menu\Programs\Accessories\System Tools\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :Result
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\SRCH SET /P SRCH=
<VARIABLE\SUCC SET /P SUCC=
<VARIABLE\FAIL SET /P FAIL=
IF !SRCH! EQU 0 (
	ECHO    �������� �߰ߵ��� �ʾҽ��ϴ�.
	>>"!QLog!" ECHO    �������� �߰ߵ��� ����
) ELSE (
	ECHO    �߰�: !SRCH! / �ʱ�ȭ: !SUCC! / �ʱ�ȭ ����: !FAIL!
	>VARIABLE\XXYY ECHO 1
)
ENDLOCAL
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Reset Service & Registry
ECHO �� �ʱ�ȭ ��� ���� �� ������Ʈ�� Ȯ���� . . . & >>"%QLog%" ECHO    �� �ʱ�ȭ ��� ���� �� ������Ʈ�� Ȯ�� :
TITLE ^(Ȯ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
REM :HKCR\exefile\shell\open\command (Default)
TITLE Ȯ���� "HKCR\exefile\shell\open\command : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCR\exefile\shell\open\command\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%A" == ""%%1" %%*" (
		>VARIABLE\TXT1 ECHO HKCR\exefile\shell\open\command
		>VARIABLE\TXT2 ECHO "%%1" %%*
		CALL :RESETREG "(Default)" NULL BACKUP "HKCR_EXEFileShell_OpenCommand"
	)
)
REM :HKCR\exefile\shell\runas\command (Default)
TITLE Ȯ���� "HKCR\exefile\shell\runas\command : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCR\exefile\shell\runas\command\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%A" == ""%%1" %%*" (
		>VARIABLE\TXT1 ECHO HKCR\exefile\shell\runas\command
		>VARIABLE\TXT2 ECHO "%%1" %%*
		CALL :RESETREG "(Default)" NULL BACKUP "HKCR_EXEFileShell_RunASCommand"
	)
)
REM :HKCR\Unknown\shell\openas\command (Default) // File Scout
TITLE Ȯ���� "HKCR\Unknown\shell\openas\command : fs_backup" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCR\Unknown\shell\openas\command\fs_backup" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKCR\Unknown\shell\openas\command
	>VARIABLE\TXT2 ECHO %%A
	CALL :RESETREG "(Default)" REG_EXPAND_SZ BACKUP "HKCR_UnknownShell_OpenASCommand"
	REG.EXE DELETE "HKCR\Unknown\shell\openas\command" /v "fs_backup" /f >Nul 2>Nul
)
REM :HKCR\Unknown\shell\openas\command (Default) // File Type Assistant
TITLE Ȯ���� "HKCR\Unknown\shell\openas\command : tsa_backup" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCR\Unknown\shell\openas\command\tsa_backup" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKCR\Unknown\shell\openas\command
	>VARIABLE\TXT2 ECHO %%A
	CALL :RESETREG "(Default)" REG_EXPAND_SZ BACKUP "HKCR_UnknownShell_OpenASCommand"
	REG.EXE DELETE "HKCR\Unknown\shell\openas\command" /v "tsa_backup" /f >Nul 2>Nul
)
REM :HKCR\Unknown\shell\opendlg\command (Default) // File Scout
TITLE Ȯ���� "HKCR\Unknown\shell\opendlg\command : fs_backup" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCR\Unknown\shell\opendlg\command\fs_backup" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKCR\Unknown\shell\opendlg\command
	>VARIABLE\TXT2 ECHO %%A
	CALL :RESETREG "(Default)" REG_EXPAND_SZ BACKUP "HKCR_UnknownShell_OpenASCommand"
	REG.EXE DELETE "HKCR\Unknown\shell\opendlg\command" /v "fs_backup" /f >Nul 2>Nul
)
REM :HKCR\Unknown\shell\opendlg\command (Default) // File Type Assistant
TITLE Ȯ���� "HKCR\Unknown\shell\opendlg\command : tsa_backup" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCR\Unknown\shell\opendlg\command\tsa_backup" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKCR\Unknown\shell\opendlg\command
	>VARIABLE\TXT2 ECHO %%A
	CALL :RESETREG "(Default)" REG_EXPAND_SZ BACKUP "HKCR_UnknownShell_OpenASCommand"
	REG.EXE DELETE "HKCR\Unknown\shell\opendlg\command" /v "tsa_backup" /f >Nul 2>Nul
)
REM :HKCU\Control Panel\Desktop (SCRNSAVE.EXE)
TITLE Ȯ���� "HKCU\Control Panel\Desktop : SCRNSAVE.EXE" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Control Panel\Desktop\SCRNSAVE.EXE" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKCU\Control Panel\Desktop
	FOR /F %%X IN ('ECHO "%%A"^|TOOLS\GREP\GREP.EXE -Fie "WINDOWS\IEUPDATE" 2^>Nul') DO (
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "SCRNSAVE.EXE" NULL BACKUP "HKCU_ControlPanelDesktop_ScrnSave"
	)
)
REM :HKCU\Software\Microsoft\Command Processor (AutoRun)
TITLE Ȯ���� "HKCU\Software\Microsoft\Command Processor : AutoRun" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Command Processor\AutoRun" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F %%X IN ('ECHO "%%A"^|TOOLS\GREP\GREP.EXE -Fie "WINDOWS\IEUPDATE" 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Command Processor
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG AutoRun NULL BACKUP "HKCU_CommandProcessor_AutoRun"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings (DnsCacheEnabled)
TITLE Ȯ���� "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings : DnsCacheEnabled" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\DnsCacheEnabled" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings
		>VARIABLE\TXT2 ECHO DELETECOMMAND
		CALL :RESETREG DnsCacheEnabled NULL BACKUP "HKCU_InternetSettings_DnsCacheEnabled"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings (DnsCacheTimeout)
TITLE Ȯ���� "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings : DnsCacheTimeout" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\DnsCacheTimeout" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings
		>VARIABLE\TXT2 ECHO DELETECOMMAND
		CALL :RESETREG DnsCacheTimeout NULL BACKUP "HKCU_InternetSettings_DnsCacheTimeout"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings (ProxyEnable)
TITLE Ȯ���� "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings : ProxyEnable" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ProxyEnable" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG ProxyEnable REG_DWORD BACKUP "HKCU_InternetSettings_ProxyEnable"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings (ServerInfoTimeOut)
TITLE Ȯ���� "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings : ServerInfoTimeOut" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ServerInfoTimeOut" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings
		>VARIABLE\TXT2 ECHO DELETECOMMAND
		CALL :RESETREG ServerInfoTimeOut NULL BACKUP "HKCU_InternetSettings_ServerInfoTimeOut"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Run (Default)
TITLE Ȯ���� "HKCU\Software\Microsoft\Windows\CurrentVersion\Run : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Run\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Run
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKCU_Run"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run (Default)
TITLE Ȯ���� "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKCU_Run(x86)"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce (Default)
TITLE Ȯ���� "HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKCU_RunOnce"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce (Default)
TITLE Ȯ���� "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKCU_RunOnce(x86)"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\RunServices (Default)
TITLE Ȯ���� "HKCU\Software\Microsoft\Windows\CurrentVersion\RunServices : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\RunServices\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\RunServices
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKCU_RunServices"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices (Default)
TITLE Ȯ���� "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKCU_RunServices(x86)"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce (Default)
TITLE Ȯ���� "HKCU\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKCU_RunServicesOnce"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce (Default)
TITLE Ȯ���� "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKCU_RunServicesOnce(x86)"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer (NoFolderOptions)
TITLE Ȯ���� "HKCU\Software\��������\Policies\Explorer : NoFolderOptions" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoFolderOptions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG NoFolderOptions REG_DWORD BACKUP "HKCU_PoliciesExplorer"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer (NoFolderOptions)
TITLE Ȯ���� "HKCU\Software\Wow6432Node\��������\Policies\Explorer : NoFolderOptions" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoFolderOptions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG NoFolderOptions REG_DWORD BACKUP "HKCU_PoliciesExplorer(x86)"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer (NoWindowsUpdate)
TITLE Ȯ���� "HKCU\Software\��������\Policies\Explorer : NoWindowsUpdate" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoWindowsUpdate" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG NoWindowsUpdate REG_DWORD BACKUP "HKCU_PoliciesExplorer"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer (NoWindowsUpdate)
TITLE Ȯ���� "HKCU\Software\Wow6432Node\��������\Policies\Explorer : NoWindowsUpdate" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoWindowsUpdate" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG NoWindowsUpdate REG_DWORD BACKUP "HKCU_PoliciesExplorer(x86)"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run (Default)
TITLE Ȯ���� "HKCU\Software\��������\Policies\Explorer\Run : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKCU_PoliciesExplorerRun"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run (Default)
TITLE Ȯ���� "HKCU\Software\Wow6432Node\��������\Policies\Explorer\Run : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKCU_PoliciesExplorerRun(x86)"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System (DisableRegistryTools)
TITLE Ȯ���� "HKCU\Software\��������\Policies\System : DisableRegistryTools" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableRegistryTools" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG DisableRegistryTools REG_DWORD BACKUP "HKCU_PoliciesSystem"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\System (DisableRegistryTools)
TITLE Ȯ���� "HKCU\Software\Wow6432Node\��������\Policies\System : DisableRegistryTools" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\System\DisableRegistryTools" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\System
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG DisableRegistryTools REG_DWORD BACKUP "HKCU_PoliciesSystem(x86)"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System (DisableTaskMgr)
TITLE Ȯ���� "HKCU\Software\��������\Policies\System : DisableTaskMgr" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableTaskMgr" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG DisableTaskMgr REG_DWORD BACKUP "HKCU_PoliciesSystem"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\System (DisableTaskMgr)
TITLE Ȯ���� "HKCU\Software\Wow6432Node\��������\Policies\System : DisableTaskMgr" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\System\DisableTaskMgr" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\System
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG DisableTaskMgr REG_DWORD BACKUP "HKCU_PoliciesSystem(x86)"
	)
)
REM :HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows (Load)
TITLE Ȯ���� "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows : Load" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows\Load" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows
	>VARIABLE\TXT2 ECHO NULL
	CALL :RESETREG Load NULL BACKUP "HKCU_WinNT_Windows"
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows (Load)
TITLE Ȯ���� "HKCU\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows : Load" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows\Load" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows
	>VARIABLE\TXT2 ECHO NULL
	CALL :RESETREG Load NULL BACKUP "HKCU_WinNT_Windows(x86)"
)
REM :HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows (Run)
TITLE Ȯ���� "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows : Run" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows
	>VARIABLE\TXT2 ECHO NULL
	CALL :RESETREG Run NULL BACKUP "HKCU_WinNT_Windows"
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows (Run)
TITLE Ȯ���� "HKCU\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows : Run" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows
	>VARIABLE\TXT2 ECHO NULL
	CALL :RESETREG Run NULL BACKUP "HKCU_WinNT_Windows(x86)"
)
REM :HKCU\Software\Microsoft\Windows NT\CurrentVersion\Winlogon (Shell)
TITLE Ȯ���� "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Winlogon : Shell" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%~nxA
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_REG_WINLOGON_SHELL.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
		>VARIABLE\TXT2 ECHO explorer.exe
		CALL :RESETREG Shell NULL BACKUP "HKCU_WinNT_Winlogon"
	)
)
REM :HKLM\Software\Classes\Unknown\shell\openas\command (Default) // File Scout
TITLE Ȯ���� "HKLM\Software\Classes\Unknown\shell\openas\command : fs_backup" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Classes\Unknown\shell\openas\command\fs_backup" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKLM\Software\Classes\Unknown\shell\openas\command
	>VARIABLE\TXT2 ECHO %%A
	CALL :RESETREG "(Default)" REG_EXPAND_SZ BACKUP "HKLM_UnknownShellOpenASCommand"
	REG.EXE DELETE "HKLM\Software\Classes\Unknown\shell\openas\command" /v "fs_backup" /f >Nul 2>Nul
)
REM :HKLM\Software\Classes\Unknown\shell\openas\command (Default) // File Type Assistant
TITLE Ȯ���� "HKLM\Software\Classes\Unknown\shell\openas\command : tsa_backup" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Classes\Unknown\shell\openas\command\tsa_backup" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKLM\Software\Classes\Unknown\shell\openas\command
	>VARIABLE\TXT2 ECHO %%A
	CALL :RESETREG "(Default)" REG_EXPAND_SZ BACKUP "HKLM_UnknownShellOpenASCommand"
	REG.EXE DELETE "HKLM\Software\Classes\Unknown\shell\openas\command" /v "tsa_backup" /f >Nul 2>Nul
)
REM :HKLM\Software\Clients\StartMenuInternet\firefox.exe\shell\open\command (Default)
TITLE Ȯ���� "HKLM\Software\Clients\StartMenuInternet\firefox.EXE\shell\open\command : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Clients\StartMenuInternet\firefox.exe\shell\open\command\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Clients\StartMenuInternet\firefox.exe\shell\open\command
		>VARIABLE\TXT2 ECHO "%PROGRAMFILESX86%\Mozilla Firefox\firefox.exe"
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_SW_Clients_StartMenuInternet_MozillaFirefox_ShellOpenCommand"
	)
)
REM :HKLM\Software\Clients\StartMenuInternet\Google Chrome\shell\open\command (Default)
TITLE Ȯ���� "HKLM\Software\Clients\StartMenuInternet\Google Chrome\shell\open\command : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Clients\StartMenuInternet\Google Chrome\shell\open\command\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Clients\StartMenuInternet\Google Chrome\shell\open\command
		>VARIABLE\TXT2 ECHO "%PROGRAMFILESX86%\Google\Chrome\Application\chrome.exe"
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_SW_Clients_StartMenuInternet_GoogleChrome_ShellOpenCommand"
	)
)
REM :HKLM\Software\Clients\StartMenuInternet\iexplore.exe\shell\open\command (Default)
TITLE Ȯ���� "HKLM\Software\Clients\StartMenuInternet\iexplore.EXE\shell\open\command : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Clients\StartMenuInternet\iexplore.exe\shell\open\command\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Clients\StartMenuInternet\iexplore.exe\shell\open\command
		>VARIABLE\TXT2 ECHO %MZKPROGRAMFILES%\Internet Explorer\iexplore.exe
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_SW_Clients_StartMenuInternet_InternetExplorer_ShellOpenCommand"
	)
)
REM :HKLM\Software\Microsoft\Command Processor (AutoRun)
TITLE Ȯ���� "HKLM\Software\Microsoft\Command Processor : AutoRun" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Command Processor\AutoRun" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F %%X IN ('ECHO "%%A"^|TOOLS\GREP\GREP.EXE -Fie "WINDOWS\IEUPDATE" 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Command Processor
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG AutoRun NULL BACKUP "HKLM_CommandProcessor_AutoRun"
	)
)
REM :HKLM\Software\Microsoft\Security Center (AntiVirusDisableNotify)
TITLE Ȯ���� "HKLM\Software\Microsoft\Security Center : AntiVirusDisableNotify" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Security Center\AntiVirusDisableNotify" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Security Center
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG AntiVirusDisableNotify REG_DWORD BACKUP "HKLM_SecurityCenter"
	)
)
REM :HKLM\Software\Microsoft\Security Center (FirewallDisableNotify)
TITLE Ȯ���� "HKLM\Software\Microsoft\Security Center : FirewallDisableNotify" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Security Center\FirewallDisableNotify" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Security Center
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG FirewallDisableNotify REG_DWORD BACKUP "HKLM_SecurityCenter"
	)
)
REM :HKLM\Software\Microsoft\Security Center (UpdatesDisableNotify)
TITLE Ȯ���� "HKLM\Software\Microsoft\Security Center : UpdatesDisableNotify" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Security Center\UpdatesDisableNotify" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Security Center
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG UpdatesDisableNotify REG_DWORD BACKUP "HKLM_SecurityCenter"
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden (Type)
TITLE Ȯ���� "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden : Type" 2>Nul
TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden\Type" >Nul 2>Nul
IF %ERRORLEVEL% EQU 1 (
	>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden
	>VARIABLE\TXT2 ECHO group
	CALL :RESETREG Type NULL NULL NULL
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Run (Default)
TITLE Ȯ���� "HKLM\Software\Microsoft\Windows\CurrentVersion\Run : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\Run\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Run
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_Run"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run (Default)
TITLE Ȯ���� "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_Run(x86)"
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce (Default)
TITLE Ȯ���� "HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_RunOnce"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce (Default)
TITLE Ȯ���� "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_RunOnce(x86)"
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices (Default)
TITLE Ȯ���� "HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_RunServices"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices (Default)
TITLE Ȯ���� "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_RunServices(x86)"
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce (Default)
TITLE Ȯ���� "HKLM\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_RunServicesOnce"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce (Default)
TITLE Ȯ���� "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_RunServicesOnce(x86)"
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer (NoFolderOptions)
TITLE Ȯ���� "HKLM\Software\��������\Policies\Explorer : NoFolderOptions" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoFolderOptions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG NoFolderOptions REG_DWORD BACKUP "HKLM_PoliciesExplorer"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer (NoFolderOptions)
TITLE Ȯ���� "HKLM\Software\Wow6432Node\��������\Policies\Explorer : NoFolderOptions" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoFolderOptions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG NoFolderOptions REG_DWORD BACKUP "HKLM_PoliciesExplorer(x86)"
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer (NoControlPanel)
TITLE Ȯ���� "HKLM\Software\��������\Policies\Explorer : NoControlPanel" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoControlPanel" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG NoControlPanel REG_DWORD BACKUP "HKLM_PoliciesExplorer"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer (NoControlPanel)
TITLE Ȯ���� "HKLM\Software\Wow6432Node\��������\Policies\Explorer : NoControlPanel" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoControlPanel" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG NoControlPanel REG_DWORD BACKUP "HKLM_PoliciesExplorer(x86)"
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer (NoTrayItemsDisplay)
TITLE Ȯ���� "HKLM\Software\��������\Policies\Explorer : NoTrayItemsDisplay" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoTrayItemsDisplay" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG NoTrayItemsDisplay REG_DWORD BACKUP "HKLM_PoliciesExplorer"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer (NoTrayItemsDisplay)
TITLE Ȯ���� "HKLM\Software\Wow6432Node\��������\Policies\Explorer : NoTrayItemsDisplay" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoTrayItemsDisplay" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG NoTrayItemsDisplay REG_DWORD BACKUP "HKLM_PoliciesExplorer(x86)"
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run (Default)
TITLE Ȯ���� "HKLM\Software\��������\Policies\Explorer\Run : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_PoliciesExplorerRun"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run (Default)
TITLE Ȯ���� "HKLM\Software\Wow6432Node\��������\Policies\Explorer\Run : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_PoliciesExplorerRun(x86)"
	)
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon (Shell)
TITLE Ȯ���� "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon : Shell" 2>Nul
>VARIABLE\TXTX TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell" 2>Nul|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /S VARIABLE\TXTX 2^>Nul') DO (
	IF %%~zA LEQ 4 (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
		>VARIABLE\TXT2 ECHO explorer.exe
		CALL :RESETREG Shell NULL NULL NULL
	) ELSE (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_REG_WINLOGON_SHELL.DB VARIABLE\TXTX 2^>Nul') DO (
			>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
			>VARIABLE\TXT2 ECHO explorer.exe
			CALL :RESETREG Shell NULL BACKUP "HKLM_WinNT_Winlogon"
		)
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon (Shell)
IF /I "%ARCHITECTURE%" == "x64" (
	TITLE Ȯ���� "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon : Shell" 2>Nul
	>VARIABLE\TXTX TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell" 2>Nul|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2>Nul
	FOR /F "DELIMS=" %%A IN ('DIR /B /S VARIABLE\TXTX 2^>Nul') DO (
		IF %%~zA LEQ 4 (
			>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon
			>VARIABLE\TXT2 ECHO explorer.exe
			CALL :RESETREG Shell NULL NULL NULL
		) ELSE (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_REG_WINLOGON_SHELL.DB VARIABLE\TXTX 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon
				>VARIABLE\TXT2 ECHO explorer.exe
				CALL :RESETREG Shell NULL BACKUP "HKLM_WinNT_Winlogon(x86)"
			)
		)
	)
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon (System)
TITLE Ȯ���� "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon : System" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\System" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
	>VARIABLE\TXT2 ECHO NULL
	CALL :RESETREG System NULL BACKUP "HKLM_WinNT_Winlogon"
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon (Userinit)
TITLE Ȯ���� "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon : Userinit" 2>Nul
TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Userinit" >Nul 2>Nul
IF %ERRORLEVEL% EQU 1 (
	>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
	>VARIABLE\TXT2 ECHO %MZKSYSTEMROOT%\System32\Userinit.exe,
	CALL :RESETREG Userinit NULL NULL NULL
) ELSE (
	FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Userinit" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
		IF /I NOT "%%~A" == "%SYSTEMROOT%\System32\Userinit.exe," (
			>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
			>VARIABLE\TXT2 ECHO %MZKSYSTEMROOT%\System32\Userinit.exe,
			CALL :RESETREG Userinit NULL BACKUP "HKLM_WinNT_Winlogon"
		)
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon (Userinit)
IF /I "%ARCHITECTURE%" == "x64" (
	TITLE Ȯ���� "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon : Userinit" 2>Nul
	TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon\Userinit" >Nul 2>Nul
	IF %ERRORLEVEL% EQU 1 (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon
		>VARIABLE\TXT2 ECHO %MZKSYSTEMROOT%\System32\Userinit.exe,
		CALL :RESETREG Userinit NULL NULL NULL
	) ELSE (
		FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon\Userinit" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			IF /I NOT "%%~A" == "%SYSTEMROOT%\System32\Userinit.exe," (
				IF /I NOT "%%~A" == "Userinit.exe" (
					>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon
					>VARIABLE\TXT2 ECHO %MZKSYSTEMROOT%\System32\Userinit.exe,
					CALL :RESETREG Userinit NULL BACKUP "HKLM_WinNT_Winlogon(x86)"
				)
			)
		)
	)
)
REM :HKLM\Software\Policies\Google\Update (UpdateDefault)
TITLE Ȯ���� "HKLM\Software\Policies\Google\Update : UpdateDefault" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Policies\Google\Update\UpdateDefault" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "1" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Policies\Google\Update
		>VARIABLE\TXT2 ECHO 1
		CALL :RESETREG UpdateDefault REG_DWORD BACKUP "HKLM_PoliciesGoogleUpdate"
	)
)
REM :HKLM\Software\Wow6432Node\Policies\Google\Update (UpdateDefault)
TITLE Ȯ���� "HKLM\Software\Wow6432Node\Policies\Google\Update : UpdateDefault" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Policies\Google\Update\UpdateDefault" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "1" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Policies\Google\Update
		>VARIABLE\TXT2 ECHO 1
		CALL :RESETREG UpdateDefault REG_DWORD BACKUP "HKLM_PoliciesGoogleUpdate(x86)"
	)
)
REM :HKLM\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings (ProxySettingsPerUser)
TITLE Ȯ���� "HKLM\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings : ProxySettingsPerUser" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ProxySettingsPerUser" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings
		>VARIABLE\TXT2 ECHO DELETECOMMAND
		CALL :RESETREG ProxySettingsPerUser NULL BACKUP "HKLM_Policies_InternetSettings_ProxySettingsPerUser"
	)
)
REM :HKLM\Software\Wow6432Node\Policies\Microsoft\Windows\CurrentVersion\Internet Settings (ProxySettingsPerUser)
TITLE Ȯ���� "HKLM\Software\Wow6432Node\Policies\Microsoft\Windows\CurrentVersion\Internet Settings : ProxySettingsPerUser" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ProxySettingsPerUser" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Policies\Microsoft\Windows\CurrentVersion\Internet Settings
		>VARIABLE\TXT2 ECHO DELETECOMMAND
		CALL :RESETREG ProxySettingsPerUser NULL BACKUP "HKLM_Policies_InternetSettings_ProxySettingsPerUser(x86)"
	)
)
REM :HKLM\System\CurrentControlSet\Services\6to4\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\6to4\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "6TO4SVC.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\6to4\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\6to4svc.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_6to4_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\AeLookupSvc\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\AeLookupSvc\ParametersServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "AELUPSVC.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\AeLookupSvc\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\aelupsvc.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_AeLookupSvc_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\Appinfo\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Appinfo\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "APPINFO.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\Appinfo\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\appinfo.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_Appinfo_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\AppMgmt\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\AppMgmt\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "APPMGMTS.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\AppMgmt\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\appmgmts.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_AppMgmt_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\BITS (Type)
FOR /F "TOKENS=3 DELIMS= " %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\BITS\Type" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%A" == "32" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\BITS
		>VARIABLE\TXT2 ECHO 32
		CALL :RESETREG Type REG_DWORD BACKUP "Services_BITS"
	)
)
REM :HKLM\System\CurrentControlSet\Services\BITS\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\BITS\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "QMGR.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\BITS\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\qmgr.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_BITS_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\Browser\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Browser\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "BROWSER.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\Browser\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\browser.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_Browser_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\dmserver\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\dmserver\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "DMSERVER.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\dmserver\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\dmserver.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_dmserver_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\DsmSvc\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\DsmSvc\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "DEVICESETUPMANAGER.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\DsmSvc\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\DeviceSetupManager.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_DsmSvc_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\FastUserSwitchingCompatibility\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\FastUserSwitchingCompatibility\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "SHSVCS.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\FastUserSwitchingCompatibility\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\shsvcs.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_FastUserSwitchingCompatibility_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\Ias\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Ias\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IAS.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\Ias\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\ias.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_Ias_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\IKEEXT\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\IKEEXT\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IKEEXT.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\IKEEXT\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\ikeext.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_IKEEXT_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\Irmon\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Irmon\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IRMON.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\Irmon\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\irmon.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_Irmon_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\MSiSCSI\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\MSiSCSI\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "ISCSIEXE.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\MSiSCSI\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\iscsiexe.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_MSiSCSI_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\NWCWorkstation\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\NWCWorkstation\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "NWWKS.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\NWCWorkstation\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\nwwks.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_NWCWorkstation_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ip (DllPath)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ip\DllPath" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IPRTRMGR.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ip
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\iprtrmgr.dll
		CALL :RESETREG DllPath REG_EXPAND_SZ BACKUP "Services_RemoteAccessRouterManagersIp_DllPath"
	)
)
REM :HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ipv6 (DllPath)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ipv6\DllPath" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IPRTRMGR.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ipv6
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\iprtrmgr.dll
		CALL :RESETREG DllPath REG_EXPAND_SZ BACKUP "Services_RemoteAccessRouterManagersIpv6_DllPath"
	)
)
REM :HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ipx (DllPath)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ipx\DllPath" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IPXRTMGR.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ipx
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\ipxrtmgr.dll
		CALL :RESETREG DllPath REG_EXPAND_SZ BACKUP "Services_RemoteAccessRouterManagersIpx_DllPath"
	)
)
REM :HKLM\System\CurrentControlSet\Services\Schedule\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Schedule\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "SCHEDSVC.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\Schedule\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\schedsvc.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_Schedule_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\StiSvc\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\StiSvc\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "WIASERVC.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\StiSvc\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\wiaservc.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_StiSvc_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\SuperProServer (ImagePath)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\SuperProServer\ImagePath" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "SPNSRVNT.EXE" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\SuperProServer
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\spnsrvnt.exe
		CALL :RESETREG ImagePath REG_EXPAND_SZ BACKUP "Services_SuperProServer"
	)
)
REM :HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Winsock (HelperDllName)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Winsock\HelperDllName" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "WSHTCPIP.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Winsock
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\wshtcpip.dll
		CALL :RESETREG HelperDllName REG_EXPAND_SZ BACKUP "Services_Tcpip_ParamsWinsock"
	)
)
REM :HKLM\System\CurrentControlSet\Services\TermService\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\TermService\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "TERMSRV.DLL" (
		IF /I NOT "%%~nxA" == "RDPWRAP.DLL" (
			>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\TermService\Parameters
			>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\termsrv.dll
			CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_TermService_Params"
		)
	)
)
REM :HKLM\System\CurrentControlSet\Services\UxSms\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\UxSms\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "UXSMS.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\UxSms\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\uxsms.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_UxSms_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\Winmgmt\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Winmgmt\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "WMISVC.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\Winmgmt\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\wbem\WMIsvc.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_Winmgmt_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\WmdmPmSN\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\WmdmPmSN\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "MSPMSNSV.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\WmdmPmSN\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\mspmsnsv.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_WmdmPmSN_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\WmdmPmSp\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\WmdmPmSp\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "MSPMSPSV.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\WmdmPmSp\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\mspmspsv.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_WmdmPmSp_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\wuauserv\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\wuauserv\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "WUAUENG.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\wuauserv\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\wuaueng.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_wuauserv_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\xmlprov\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\xmlprov\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "XMLPROV.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\xmlprov\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\xmlprov.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_xmlprov_Params"
	)
)
REG.EXE DELETE "HKLM\System\CurrentControlSet\Control\Session Manager" /v PendingFileRenameOperations /f >Nul 2>Nul
REM :Result
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\SRCH SET /P SRCH=
<VARIABLE\SUCC SET /P SUCC=
<VARIABLE\FAIL SET /P FAIL=
IF !SRCH! EQU 0 (
	ECHO    �������� �߰ߵ��� �ʾҽ��ϴ�. & >>"!QLog!" ECHO    �������� �߰ߵ��� ����
) ELSE (
	ECHO    �߰�: !SRCH! / �ʱ�ȭ: !SUCC! / �ʱ�ȭ ����: !FAIL!
	>VARIABLE\XXYY ECHO 1
)
ENDLOCAL
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Delete - Registry <Program Uninstall>
ECHO �� �Ǽ� �� ���� ���� ���α׷� ��ġ ���� ������Ʈ�� ������ . . . & >>"%QLog%" ECHO    �� �Ǽ� �� ���� ���� ���α׷� ��ġ ���� ������Ʈ�� ���� :
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall
SET "STRTMP=HKCU_Uninstall"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\TXTX ECHO %%A^|
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_UNINSTALL.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_UNINSTALL.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
SET "STRTMP=HKCU_Uninstall(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\TXTX ECHO %%A^|
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_UNINSTALL.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_UNINSTALL.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall
SET "STRTMP=HKLM_Uninstall"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\TXTX ECHO %%A^|
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_UNINSTALL.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_UNINSTALL.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
SET "STRTMP=HKLM_Uninstall(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\TXTX ECHO %%A^|
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_UNINSTALL.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_UNINSTALL.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Uninstall
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Uninstall
SET "STRTMP=HKU_Uninstall"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Uninstall" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Uninstall\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\TXTX ECHO %%A^|
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_UNINSTALL.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_UNINSTALL.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
SET "STRTMP=HKU_Uninstall(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\TXTX ECHO %%A^|
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_UNINSTALL.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_UNINSTALL.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Delete - Registry <Startup>
ECHO �� �Ǽ� �� ���� ���� ���� ���α׷� ������Ʈ�� ������ . . . & >>"%QLog%" ECHO    �� �Ǽ� �� ���� ���� ���� ���α׷� ������Ʈ�� ���� :
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Run
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Microsoft\Windows\CurrentVersion\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Run
SET "STRTMP=HKCU_SoftwareRun"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "Run (HKCU) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run
SET "STRTMP=HKCU_SoftwareRun(x86)"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "Run (HKCU x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce
SET "STRTMP=HKCU_SoftwareRunOnce"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "RunOnce (HKCU) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce
SET "STRTMP=HKCU_SoftwareRunOnce(x86)"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "RunOnce (HKCU x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\RunServices
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Windows\CurrentVersion\RunServices" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Windows\CurrentVersion\RunServices" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Microsoft\Windows\CurrentVersion\RunServices" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\RunServices\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\RunServices
SET "STRTMP=HKCU_SoftwareRunServices"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "RunServices (HKCU) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices
SET "STRTMP=HKCU_SoftwareRunServices(x86)"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "RunServices (HKCU x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce
SET "STRTMP=HKCU_SoftwareRunServicesOnce"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "RunServicesOnce (HKCU) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce
SET "STRTMP=HKCU_SoftwareRunServicesOnce(x86)"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "RunServicesOnce (HKCU x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
SET "STRTMP=HKCU_SoftwarePoliciesExplorerRun"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "Policies Run (HKCU) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
SET "STRTMP=HKCU_SoftwarePoliciesExplorerRun(x86)"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "Policies Run (HKCU x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Shared Tools\MSConfig\startupreg
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Shared Tools\MSConfig\startupreg
SET "STRTMP=HKLM_SW_MSConfig_StartupReg"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Shared Tools\MSConfig\startupreg" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "Disable Run : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Shared Tools\MSConfig\startupreg\%%A\command" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			SETLOCAL ENABLEDELAYEDEXPANSION
			<VARIABLE\CHCK SET /P CHCK=
			IF !CHCK! EQU 0 (
				ENDLOCAL
				>VARIABLE\TXTX ECHO %%B
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
			) ELSE (
				ENDLOCAL
			)
			SETLOCAL ENABLEDELAYEDEXPANSION
			<VARIABLE\CHCK SET /P CHCK=
			IF !CHCK! EQU 0 (
				ENDLOCAL
				>VARIABLE\TXTX ECHO %%B
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
			) ELSE (
				ENDLOCAL
			)
			SETLOCAL ENABLEDELAYEDEXPANSION
			<VARIABLE\CHCK SET /P CHCK=
			IF !CHCK! EQU 0 (
				ENDLOCAL
				IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
					>VARIABLE\TXTX ECHO "%%~dpnxB"
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
				) ELSE (
					ENDLOCAL
				)
			)
			SETLOCAL ENABLEDELAYEDEXPANSION
			<VARIABLE\CHCK SET /P CHCK=
			IF !CHCK! EQU 0 (
				ENDLOCAL
				IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
					>VARIABLE\TXTX ECHO "%%~dpB"
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
				)
			) ELSE (
				ENDLOCAL
			)
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Run
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Run
SET "STRTMP=HKLM_SoftwareRun"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "Run (HKLM) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run
SET "STRTMP=HKLM_SoftwareRun(x86)"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "Run (HKLM x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce
SET "STRTMP=HKLM_SoftwareRunOnce"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "RunOnce (HKLM) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce
SET "STRTMP=HKLM_SoftwareRunOnce(x86)"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "RunOnce (HKLM x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices
SET "STRTMP=HKLM_SoftwareRunServices"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "RunServices (HKLM) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices
SET "STRTMP=HKLM_SoftwareRunServices(x86)"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "RunServices (HKLM x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce
SET "STRTMP=HKLM_SoftwareRunServicesOnce"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "RunServicesOnce (HKLM) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce
SET "STRTMP=HKLM_SoftwareRunServicesOnce(x86)"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "RunServicesOnce (HKLM x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
SET "STRTMP=HKLM_SoftwarePoliciesExplorerRun"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "Policies Run (HKLM) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
SET "STRTMP=HKLM_SoftwarePoliciesExplorerRun(x86)"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "Policies Run (HKLM x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify
SET "STRTMP=HKLM_WinlogonNotify"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "Notify : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_WINLOGON_NOTIFY.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify
SET "STRTMP=HKLM_WinlogonNotify(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE �˻��� "Notify (x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_WINLOGON_NOTIFY.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Run
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Run" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Run
SET "STRTMP=HKU_SoftwareRun"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "Run (HKU) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run
SET "STRTMP=HKU_SoftwareRun(x86)"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "Run (HKU x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunOnce
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunOnce" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunOnce
SET "STRTMP=HKU_SoftwareRunOnce"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "RunOnce (HKU) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce
SET "STRTMP=HKU_SoftwareRunOnce(x86)"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "RunOnce (HKU x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServices
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServices" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServices" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServices" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServices\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServices
SET "STRTMP=HKU_SoftwareRunServices"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "RunServices (HKU) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices
SET "STRTMP=HKU_SoftwareRunServices(x86)"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "RunServices (HKU x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce
SET "STRTMP=HKU_SoftwareRunServicesOnce"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "RunServicesOnce (HKU) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce
SET "STRTMP=HKU_SoftwareRunServicesOnce(x86)"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "RunServicesOnce (HKU x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
SET "STRTMP=HKU_SoftwarePoliciesExplorerRun"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "Policies Run (HKU) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A��%%B
)
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
SET "STRTMP=HKU_SoftwarePoliciesExplorerRun(x86)"
FOR /F "TOKENS=1,2 DELIMS=��" %%A IN (VARIABLE\RGST) DO (
	TITLE �˻��� "Policies Run (HKU x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Repository Salvage Windows Management Instrumentation
ECHO �� ���� ���� �������丮 ������ . . .
TITLE ^(������^) ��ø� ��ٷ��ּ��� . . . 2>Nul
WINMGMT.EXE /SALVAGEREPOSITORY >Nul 2>Nul
ECHO    �Ϸ�Ǿ����ϴ�.

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO.

REM * Repair Service
<VARIABLE\XXXX SET /P XXXX=
IF %XXXX% EQU 1 (
	ECHO �� �Ǽ��ڵ忡 ���� ��Ȱ��ȭ�� ���� Ȯ���� . . .
	FOR /F "TOKENS=1,2 DELIMS=|" %%A IN (DB_EXEC\REPAIR_SERVICE.DB) DO (
		IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
			TITLE Ȯ���� "%%A" 2>Nul
			SC.EXE CONFIG "%%A" START= %%B >Nul 2>Nul
		)
	)
	ECHO    �Ϸ�Ǿ����ϴ�.
	PING.EXE -n 2 0 >Nul 2>Nul
	ECHO.
)

REM * Reset Network DNS Address <#2>
ECHO �� ��Ʈ��ũ DNS �ּ� ���� Ȯ���� - 2�� . . . & >>"%QLog%" ECHO    �� ��Ʈ��ũ DNS �ּ� ���� Ȯ�� - 2�� :
TITLE ^(Ȯ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %%A
	FOR /F "TOKENS=1,2 DELIMS=," %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%A\NameServer" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
		IF NOT "%%B" == "" (
			IF NOT "%%C" == "" (
				>VARIABLE\TXT2 ECHO %%B^|%%C
				>VARIABLE\TXTX ECHO %%B,%%C
				IF "%%B" == "%%C" (
					CALL :RESETDNS
				) ELSE (
					>VARIABLE\CHCK ECHO 0
					SETLOCAL ENABLEDELAYEDEXPANSION
					<VARIABLE\CHCK SET /P CHCK=
					IF !CHCK! EQU 0 (
						ENDLOCAL
						FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\NETWORK\DEL_DNS_ADDRESS.DB VARIABLE\TXTX 2^>Nul') DO CALL :RESETDNS
					) ELSE (
						ENDLOCAL
					)
					SETLOCAL ENABLEDELAYEDEXPANSION
					<VARIABLE\CHCK SET /P CHCK=
					IF !CHCK! EQU 0 (
						ENDLOCAL
						FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\NETWORK\PATTERN_DNS_ADDRESS.DB VARIABLE\TXTX 2^>Nul') DO CALL :RESETDNS
					) ELSE (
						ENDLOCAL
					)
				)
			) ELSE (
				>VARIABLE\TXT2 ECHO %%B
				>VARIABLE\CHCK ECHO 0
				SETLOCAL ENABLEDELAYEDEXPANSION
				<VARIABLE\CHCK SET /P CHCK=
				IF !CHCK! EQU 0 (
					ENDLOCAL
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\NETWORK\DEL_DNS_ADDRESS.DB VARIABLE\TXT2 2^>Nul') DO CALL :RESETDNS
				) ELSE (
					ENDLOCAL
				)
				SETLOCAL ENABLEDELAYEDEXPANSION
				<VARIABLE\CHCK SET /P CHCK=
				IF !CHCK! EQU 0 (
					ENDLOCAL
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\NETWORK\PATTERN_DNS_ADDRESS.DB VARIABLE\TXT2 2^>Nul') DO CALL :RESETDNS
				) ELSE (
					ENDLOCAL
				)
			)
		)
	)
)
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\CHCK SET /P CHCK=
IF !CHCK! EQU 0 (
	ECHO    �������� �߰ߵ��� �ʾҽ��ϴ�. & >>"%QLog%" ECHO    �������� �߰ߵ��� ����
) ELSE (
	>VARIABLE\XXYY ECHO 1
)
ENDLOCAL
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Check - Required System Files <#2>
ECHO �� �ʼ� �ý��� ���� Ȯ���� - 2�� . . . & >>"%QLog%" ECHO    �� �ʼ� �ý��� ���� Ȯ�� - 2�� :
FOR /F "TOKENS=1,2,3 DELIMS=|" %%A IN (DB_EXEC\CHECK\CHK_SYSTEMFILE.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		IF EXIST "DB_EXEC\MD5CHK\CHK_MD5_%%A.DB" (
			>VARIABLE\TXT2 ECHO %%A
			TITLE Ȯ���� "%%A" 2>Nul
			IF %%B EQU 1 (
				>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%
				CALL :CHK_SYSX
			) ELSE (
				IF %%C EQU 1 (
					IF /I "%ARCHITECTURE%" == "x64" (
						>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64
					) ELSE (
						>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32
					)
					CALL :CHK_SYSX
				) ELSE (
					IF /I "%ARCHITECTURE%" == "x64" (
						>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64
						CALL :CHK_SYSX
					)
					>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32
					CALL :CHK_SYSX
				)
			)
		)
	)
)
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\SRCH SET /P SRCH=
<VARIABLE\FAIL SET /P FAIL=
IF !SRCH! EQU 0 (
	ECHO    �������� �߰ߵ��� �ʾҽ��ϴ�. & >>"%QLog%" ECHO    �������� �߰ߵ��� ����
) ELSE (
	>VARIABLE\XXYY ECHO 1
	IF !FAIL! EQU 1 (
		ECHO. & >>"!QLog!" ECHO.
		ECHO    �� �� ���� ��� Ȯ�� �� ^<3. ���� �ذ�^> ���� ^<���� 13^> �׸� ���� & >>"!QLog!" ECHO    �� ^<3. ���� �ذ�^> ���� ^<���� 13^> �׸� ����
	)
)
ENDLOCAL
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Delete - Temporary & Cache Files #2
ECHO �� �ӽ� ����/���� ������ - 2�� . . .
TITLE ^(������^) ��ø� ��ٷ��ּ��� ^(�ð��� �ټ� �ҿ�� �� ����^) . . . 2>Nul
DEL /F /Q /S /A "%SYSTEMROOT%\Temp" >Nul 2>Nul
DEL /F /Q /S /A "%APPDATA%\Temp" >Nul 2>Nul
DEL /F /Q /S /A "%TEMP%" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMDRIVE%\*.TEMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMDRIVE%\*.TMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\*.TEMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\*.TMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\System\*.TEMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\System\*.TMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\System32\*.TMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\System32\*.TEMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\SysWOW64\*.TMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\SysWOW64\*.TEMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\System32\Drivers\*.TEMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\System32\Drivers\*.TMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\SysWOW64\Drivers\*.TEMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\SysWOW64\Drivers\*.TMP" >Nul 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\CHECK\CHK_PROCESSKILL_BROWSER.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ MZK CHECK CHK_PROCESSKILL_BROWSER.DB ~~~~~~~~~~" TOOLS\TASKS\TASKKILL.EXE /F /IM "%%A" >Nul 2>Nul
)
DEL /F /Q /A "%LOCALAPPDATA%\Chromium\User Data\Default\Application Cache\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\Chromium\User Data\Default\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Application Cache\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Application Cache\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Application Cache\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Application Cache\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\SwingBrowser\User Data\Default\Application Cache\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\SwingBrowser\User Data\Default\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\Steam\htmlcache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\Opera Software\Opera Stable\Cache\*" >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Mozilla\Firefox\Profiles\" 2^>Nul') DO (
	DEL /F /Q /A "%LOCALAPPDATA%\Mozilla\Firefox\Profiles\%%A\Cache\Entries\*" >Nul 2>Nul
	DEL /F /Q /A "%LOCALAPPDATA%\Mozilla\Firefox\Profiles\%%A\Cache2\Entries\*" >Nul 2>Nul
)
IF EXIST "%SYSTEMROOT%\System32\InetCpl.cpl" (
	RUNDLL32.EXE InetCpl.cpl,ClearMyTracksByProcess 4 >Nul 2>Nul
)
ECHO    �Ϸ�Ǿ����ϴ�.

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO.

REM * Reset - Restart DNS Client Service
SETLOCAL ENABLEDELAYEDEXPANSION
SC.EXE STOP DNSCACHE >Nul 2>Nul
IF !ERRORLEVEL! NEQ 1062 (
	IF !ERRORLEVEL! EQU 0 (
		PING.EXE -n 2 0 >Nul 2>Nul
		IPCONFIG.EXE /FLUSHDNS >Nul 2>Nul
		SC.EXE START DNSCACHE >Nul 2>Nul
	)
)
ENDLOCAL

<VARIABLE\XXXX SET /P XXXX=
<VARIABLE\XXYY SET /P XXYY=
IF %XXXX% EQU 0 (
	IF %XXYY% EQU 0 (
		COLOR 2F
	) ELSE (
		COLOR 6F
	)
)

REM * Reset - Count Value (All)
CALL :RESETVAL ALL

TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "%QFolders%" -ot file -actn rstchldrn -rst "dacl,sacl" -silent >Nul 2>Nul

RMDIR "%QRoot%\Files\%RPTDATE%" /Q >Nul 2>Nul
RMDIR "%QRoot%\Folders\%RPTDATE%" /Q >Nul 2>Nul
RMDIR "%QRoot%\Registrys\%RPTDATE%" /Q >Nul 2>Nul

REM * Finished
ECHO =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
ECHO.
ECHO �� �˻� �Ϸ�Ǿ����ϴ� . . .

COPY /Y "Malware Zero Kit - Virus Zero Season 2.html" "%USERPROFILE%\Desktop\" >Nul 2>Nul

>>"%QLog%" ECHO -- ���� --
>>"%QLog%" ECHO.
>>"%QLog%" ECHO    Virus Zero Season 2 : http://cafe.naver.com/malzero
>>"%QLog%" ECHO    Batch Script : ViOLeT ^(archguru^)
>>"%QLog%" ECHO.
>>"%QLog%" ECHO    ��� ^! Ÿ ����Ʈ/ī��/��α�/�䷻Ʈ ��� ����/���� �� ����� �̿� ���� ���� ^! ^(�߽߰� �Ű� ���^)
>>"%QLog%" ECHO.
>>"%QLog%" ECHO -- E --

IF %VK% EQU 1 START TOOLS\MAGNETOK\MAGNETOK.EXE >Nul 2>Nul

GOTO END

:FAILED
ECHO �� ����: ���� ���� ���� ^(������ �������� ���� �ʼ�^)
ECHO.
ECHO �� �ذ�: ���� ���� ���� �� ���콺 ������ ��ư�� Ŭ���Ͽ� "������ �������� ����" �׸� Ŭ��
GOTO END

:NOFILE
ECHO �� ����: �ʼ� ������ �������� �ʰų� ����� ���·� ����
ECHO.
ECHO �� �ذ�: �����Ǿ� �ִ� ^<3. ���� �ذ�^> ���� ^<���� 02^> �׸� ����
GOTO END

:NOSYSF
ECHO �� ����: �ý��� ������ �������� ���� ^(���� ����: "%STRTMP%"^) & GOTO END

:FAILEDOS
ECHO �� ����: �������� �ʴ� �ü��
ECHO.
ECHO �� ���� ���� ���� �ü��: Microsoft Windows Vista, 7, 2008, 8, 2012, 10
GOTO END

:NOVAR
ECHO �� ����: �ʼ� ȯ�� ������ �������� �ʰų� �ùٸ��� ����
ECHO.
ECHO �� �ذ�: ȯ�� ���� ���� ����
GOTO END

:MALWARE
ECHO �� ����: �Ǽ��ڵ忡 ���� ���� ����
ECHO.
ECHO �� �ذ�: �����Ǿ� �ִ� ^<3. ���� �ذ�^> ���� ^<���� 09^> �׸� ����
GOTO END

:REGBLOCK
ECHO �� ����: ������Ʈ�� ���� ���� ����
ECHO.
ECHO �� �ذ�: �����Ǿ� �ִ� ^<3. ���� �ذ�^> ���� ^<���� 02^> �׸� ����
GOTO END

:NOCOUNT
ECHO �� ����: �����ͺ��̽� ���� ������ ��ġ���� ���� ^(�Ǵ� ���� ���� ����^)
ECHO.
ECHO �� �ذ�: ������ ���� ������ ��ũ��Ʈ ���� �� ���� ��ü ���� �� ���� ���� ���� �� ����
ECHO          ������ ���ӵ� ��� ^<3. ���� �ذ�^> ���� ^<���� 02^> �׸� ����
GOTO END

:CHK_SYSF
SETLOCAL ENABLEDELAYEDEXPANSION
SET TXT1=
<VARIABLE\TXT1 SET /P TXT1=
IF NOT DEFINED TXT1 (
	ENDLOCAL
	GOTO :EOF
)
SET TXT2=
<VARIABLE\TXT2 SET /P TXT2=
IF NOT DEFINED TXT2 (
	ENDLOCAL
	GOTO :EOF
)
IF NOT EXIST "!TXT1!\!TXT2!" (
	>VARIABLE\SRCH ECHO 1
	TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
	FOR /F "TOKENS=1,* DELIMS=," %%A IN ('TOOLS\HASHDEEP\!MD5CHK!.EXE -c -s "!TXT1!\*" 2^>Nul') DO (
		TITLE Ȯ���� "!TXT2!" ^(���� Ž����^) "%%B" 2>Nul
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%A" DB_EXEC\MD5CHK\CHK_MD5_!TXT2!.DB 2^>Nul') DO (
			REN "!TXT1!\%%~nxB" "!TXT2!" >Nul 2>Nul
			IF EXIST "!TXT1!\!TXT2!" (
				ECHO    "!TXT2!" ���� ���� ^(��ġ: "!TXT1!"^) & >>"!QLog!" ECHO    "!TXT2!" ���� ���� ^(��ġ: "!TXT1!"^)
			)
		)
	)
	IF NOT EXIST "!TXT1!\!TXT2!" (
		COLOR 4F
		ECHO    "!TXT2!" ������ �������� ���� ^(��ġ: "!TXT1!"^) & >>"!QLog!" ECHO    "!TXT2!" ������ �������� ���� ^(��ġ: "!TXT1!"^)
	)
)
ENDLOCAL
GOTO :EOF

:CHK_SYSX
SETLOCAL ENABLEDELAYEDEXPANSION
SET TXT1=
<VARIABLE\TXT1 SET /P TXT1=
IF NOT DEFINED TXT1 (
	ENDLOCAL
	GOTO :EOF
)
SET TXT2=
<VARIABLE\TXT2 SET /P TXT2=
IF NOT DEFINED TXT2 (
	ENDLOCAL
	GOTO :EOF
)
IF EXIST "!TXT1!\!TXT2!" (
	FOR /F "TOKENS=1" %%A IN ('TOOLS\HASHDEEP\!MD5CHK!.EXE -s -q "!TXT1!\!TXT2!" 2^>Nul') DO (
		FOR /F %%X IN ('ECHO %%A^|TOOLS\GREP\GREP.EXE -Fivxf DB_EXEC\MD5CHK\CHK_MD5_!TXT2!.DB 2^>Nul') DO (
			TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
			>VARIABLE\SRCH ECHO 1
			FOR /F "TOKENS=1,* DELIMS=," %%B IN ('TOOLS\HASHDEEP\!MD5CHK!.EXE -c -s "!TXT1!\*" 2^>Nul') DO (
				<VARIABLE\SUCC SET /P SUCC=
				IF !SUCC! EQU 0 (
					TITLE Ȯ���� "!TXT2!" ^(���� Ž����^) "%%C" 2>Nul
					FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\MD5CHK\CHK_MD5_!TXT2!.DB 2^>Nul') DO (
						REN "!TXT1!\!TXT2!" "!TXT2!.!TIME::=.!.infected" >Nul 2>Nul
						REN "!TXT1!\%%~nxC" "!TXT2!" >Nul 2>Nul
						IF !ERRORLEVEL! EQU 0 >VARIABLE\SUCC ECHO 1
					)
				)
			)
			<VARIABLE\SUCC SET /P SUCC=
			IF !SUCC! EQU 0 (
				TITLE ^(ĳ����^) ��ø� ��ٷ��ּ��� . . . 2>Nul
				FOR /F "TOKENS=1,* DELIMS=," %%B IN ('TOOLS\HASHDEEP\!MD5CHK!.EXE -c -s "!TEMP!\*" 2^>Nul') DO (
					<VARIABLE\SUCC SET /P SUCC=
					IF !SUCC! EQU 0 (
						TITLE Ȯ���� "!TXT2!" ^(���� Ž����^) "%%C" 2>Nul
						FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\MD5CHK\CHK_MD5_!TXT2!.DB 2^>Nul') DO (
							REN "!TXT1!\!TXT2!" "!TXT2!.!TIME::=.!.infected" >Nul 2>Nul
							COPY /Y "!TEMP!\%%~nxC" "!TXT1!\!TXT2!" >Nul 2>Nul
							IF !ERRORLEVEL! EQU 0 >VARIABLE\SUCC ECHO 1
						)
					)
				)
			)
			<VARIABLE\SUCC SET /P SUCC=
			IF !SUCC! EQU 1 (
				ECHO    "!TXT2!" ���� ���� ^(��ġ: "!TXT1!"^) & >>"!QLog!" ECHO    "!TXT2!" ���� ���� ^(��ġ: "!TXT1!"^)
			) ELSE (
				>VARIABLE\FAIL ECHO 1
				ECHO    "!TXT2!" ���� Ȯ�� �ʿ� ^(��ġ: "!TXT1!"^) & >>"!QLog!" ECHO    "!TXT2!" ���� Ȯ�� �ʿ� ^(��ġ: "!TXT1!"^) ^[MD5:%%A^]
			)
			>VARIABLE\SUCC ECHO 0
		)
	)
)
ENDLOCAL
GOTO :EOF

:DEL_SVC
SETLOCAL ENABLEDELAYEDEXPANSION
>VARIABLE\CHCK ECHO 1
SET TXT1=
<VARIABLE\TXT1 SET /P TXT1=
SET "TXT1=!TXT1:"=\"!"
IF NOT DEFINED TXT1 (
	ENDLOCAL
	GOTO :EOF
)
SET TXT2=
<VARIABLE\TXT2 SET /P TXT2=
SET "TXT2TXT=!TXT2!"
SET "TXT2=!TXT2:"=\"!"
IF NOT DEFINED TXT2 (
	ENDLOCAL
	GOTO :EOF
)
IF "%~1" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF "%~2" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF "%~3" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF /I "%~1" == "ACTIVESCAN" (
	SET ACTIVESCAN=1
) ELSE (
	SET ACTIVESCAN=0
)
IF /I "%~2" == "BACKUP" (
	IF /I NOT "%~3" == "NULL" (
		IF NOT EXIST "!QRegistrys!\Services%~3_!TIME::=.!_!RANDOM!.reg" (
			REG.EXE EXPORT "!TXT1!\!TXT2!" "!QRegistrys!\%~3_!TIME::=.!_!RANDOM!.reg" /y >Nul 2>Nul
		)
	)
)
TOOLS\SETACL\!ARCHITECTURE!\SETACL.EXE -on "!TXT2!" -ot srv -actn trustee -trst "n1:Everyone;ta:remtrst;w:dacl" -actn ace -ace "n:Everyone;p:full" -ace "n:Administrators;p:full" -silent >Nul 2>Nul
SC.EXE CONFIG "!TXT2!" START= DISABLED >Nul 2>Nul
SC.EXE STOP "!TXT2!" >Nul 2>Nul
IF !ERRORLEVEL! NEQ 1060 (
	IF !ERRORLEVEL! NEQ 0 (
		IF !ERRORLEVEL! NEQ 1062 (
			>VARIABLE\CHCK ECHO 2
		)
	)
)
<VARIABLE\SRCH SET /P SRCH=
SET /A SRCH+=1
>VARIABLE\SRCH ECHO !SRCH!
SC.EXE DELETE "!TXT2!" >Nul 2>Nul
IF !ERRORLEVEL! EQU 0 (
	REG.EXE DELETE "HKLM\System\CurrentControlSet\Services\!TXT2!" /f >Nul 2>Nul
	<VARIABLE\CHCK SET /P CHCK=
	<VARIABLE\SUCC SET /P SUCC=
	SET /A SUCC+=1
	>VARIABLE\SUCC ECHO !SUCC!
	IF !CHCK! LEQ 1 (
		IF !ACTIVESCAN! EQU 1 (
			>>"!QLog!" ECHO    "!TXT2TXT!" ^(�ݸ�/���� ���� ^[Active Scan^]^)
		) ELSE (
			>>"!QLog!" ECHO    "!TXT2TXT!" ^(�ݸ�/���� ����^)
		)
	) ELSE (
		<VARIABLE\RECK SET /P RECK=
		SET /A RECK+=1
		>VARIABLE\RECK ECHO !RECK!
		IF !ACTIVESCAN! EQU 1 (
			>>"!QLog!" ECHO    "!TXT2TXT!" ^(�ݸ�/���� ���� - ����� �� ���ŵ� ^[Active Scan^]^)
		) ELSE (
			>>"!QLog!" ECHO    "!TXT2TXT!" ^(�ݸ�/���� ���� - ����� �� ���ŵ�^)
		)
	)
) ELSE (
	REG.EXE DELETE "HKLM\System\CurrentControlSet\Services\!TXT2!" /f >Nul 2>Nul
	IF !ERRORLEVEL! EQU 0 (
		<VARIABLE\SUCC SET /P SUCC=
		SET /A SUCC+=1
		>VARIABLE\SUCC ECHO !SUCC!
		IF !ACTIVESCAN! EQU 1 (
			>>"!QLog!" ECHO    "!TXT2TXT!" ^(�ݸ�/���� ���� ^[Active Scan^]^)
		) ELSE (
			>>"!QLog!" ECHO    "!TXT2TXT!" ^(�ݸ�/���� ����^)
		)
	) ELSE (
		<VARIABLE\FAIL SET /P FAIL=
		SET /A FAIL+=1
		>VARIABLE\FAIL ECHO !FAIL!
		IF !ACTIVESCAN! EQU 1 (
			>>"!QLog!" ECHO    "!TXT2TXT!" ^(���� ���� ^[Active Scan^]^)
		) ELSE (
			>>"!QLog!" ECHO    "!TXT2TXT!" ^(���� ����^)
		)
	)
)
ENDLOCAL
GOTO :EOF

:DEL_BITS
SETLOCAL ENABLEDELAYEDEXPANSION
>VARIABLE\CHCK ECHO 1
IF "%~1" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF "%~2" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF /I "%1" == "ACTIVESCAN" (
	SET ACTIVESCAN=1
) ELSE (
	SET ACTIVESCAN=0
)
<VARIABLE\SRCH SET /P SRCH=
SET /A SRCH+=1
>VARIABLE\SRCH ECHO !SRCH!
BITSADMIN.EXE /CANCEL "%~2" >Nul 2>Nul
IF !ERRORLEVEL! EQU 0 (
	<VARIABLE\SUCC SET /P SUCC=
	SET /A SUCC+=1
	>VARIABLE\SUCC ECHO !SUCC!
	IF !ACTIVESCAN! EQU 1 (
		>>"!QLog!" ECHO    "%~2" ^(���� ���� ^[Active Scan^]^)
	) ELSE (
		>>"!QLog!" ECHO    "%~2" ^(���� ����^)
	)
) ELSE (
	<VARIABLE\FAIL SET /P FAIL=
	SET /A FAIL+=1
	>VARIABLE\FAIL ECHO !FAIL!
	IF !ACTIVESCAN! EQU 1 (
		>>"!QLog!" ECHO    "%~2" ^(���� ���� ^[Active Scan^]^)
	) ELSE (
		>>"!QLog!" ECHO    "%~2" ^(���� ����^)
	)
)
ENDLOCAL
GOTO :EOF

:DEL_FILE
SETLOCAL ENABLEDELAYEDEXPANSION
SET TXT1=
<VARIABLE\TXT1 SET /P TXT1=
IF NOT DEFINED TXT1 (
	ENDLOCAL
	GOTO :EOF
)
SET TXT2=
<VARIABLE\TXT2 SET /P TXT2=
IF NOT DEFINED TXT2 (
	ENDLOCAL
	GOTO :EOF
)
IF /I "%1" == "ACTIVESCAN" (
	SET ACTIVESCAN=1
) ELSE (
	SET ACTIVESCAN=0
)
<VARIABLE\SRCH SET /P SRCH=
SET /A SRCH+=1
>VARIABLE\SRCH ECHO !SRCH!
TOOLS\SETACL\!ARCHITECTURE!\SETACL.EXE -on "!TXT1!!TXT2!" -ot file -actn setowner -ownr "n:Administrators" -rec obj -silent >Nul 2>Nul
TOOLS\SETACL\!ARCHITECTURE!\SETACL.EXE -on "!TXT1!!TXT2!" -ot file -actn clear -clr "dacl,sacl" -actn setprot -op "dacl:np;sacl:np" -actn ace -ace "n:Administrators;p:full" -rec obj -silent >Nul 2>Nul
ATTRIB.EXE -R -H -S "!TXT1!!TXT2!" >Nul 2>Nul
COPY /Y "!TXT1!!TXT2!" "!QFiles!\!TXT2!.!TIME::=.!.vz" >Nul 2>Nul
DEL /F /Q /A "!TXT1!!TXT2!" >Nul 2>Nul
IF NOT EXIST "!TXT1!!TXT2!" (
	<VARIABLE\SUCC SET /P SUCC=
	SET /A SUCC+=1
	>VARIABLE\SUCC ECHO !SUCC!
	IF !ACTIVESCAN! EQU 1 (
		>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(�ݸ�/���� ���� ^[Active Scan^]^)
	) ELSE (
		>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(�ݸ�/���� ����^)
	)
) ELSE (
	REN "!TXT1!!TXT2!" "!TXT2!.vz" >Nul 2>Nul
	IF NOT EXIST "!TXT1!!TXT2!" (
		<VARIABLE\SUCC SET /P SUCC=
		SET /A SUCC+=1
		>VARIABLE\SUCC ECHO !SUCC!
		<VARIABLE\RECK SET /P RECK=
		SET /A RECK+=1
		>VARIABLE\RECK ECHO !RECK!
		IF !ACTIVESCAN! EQU 1 (
			>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(�ӽ� ���� - ����� �� ��˻� �ʿ� ^[Active Scan^]^)
		) ELSE (
			>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(�ӽ� ���� - ����� �� ��˻� �ʿ�^)
		)
	) ELSE (
		<VARIABLE\FAIL SET /P FAIL=
		SET /A FAIL+=1
		>VARIABLE\FAIL ECHO !FAIL!
		IF !ACTIVESCAN! EQU 1 (
			>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(���� ���� ^[Active Scan^]^)
		) ELSE (
			>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(���� ����^)
		)
	)
)
>>DB_ACTIVE\ACT_AUTORUN_FILE.DB ECHO "!TXT1!!TXT2!"
ENDLOCAL
GOTO :EOF

:DEL_DIRT
SETLOCAL ENABLEDELAYEDEXPANSION
SET TXT1=
<VARIABLE\TXT1 SET /P TXT1=
IF NOT DEFINED TXT1 (
	ENDLOCAL
	GOTO :EOF
)
SET TXT2=
<VARIABLE\TXT2 SET /P TXT2=
IF NOT DEFINED TXT2 (
	ENDLOCAL
	GOTO :EOF
)
IF /I "%1" == "ACTIVESCAN" (
	SET ACTIVESCAN=1
) ELSE (
	SET ACTIVESCAN=0
)
<VARIABLE\SRCH SET /P SRCH=
SET /A SRCH+=1
>VARIABLE\SRCH ECHO !SRCH!
TOOLS\SETACL\!ARCHITECTURE!\SETACL.EXE -on "!TXT1!!TXT2!" -ot file -actn setowner -ownr "n:Administrators" -rec cont_obj -actn rstchldrn -rst "dacl,sacl" -silent >Nul 2>Nul
TOOLS\SETACL\!ARCHITECTURE!\SETACL.EXE -on "!TXT1!!TXT2!" -ot file -actn clear -clr "dacl,sacl" -actn setprot -op "dacl:np;sacl:np" -actn ace -ace "n:Administrators;p:full" -rec cont_obj -actn rstchldrn -rst "dacl,sacl" -silent >Nul 2>Nul
ATTRIB.EXE -R -H -S "!TXT1!!TXT2!" >Nul 2>Nul
ATTRIB.EXE -R -H -S "!TXT1!!TXT2!\*" /S /D >Nul 2>Nul
XCOPY.EXE "!TXT1!!TXT2!" "!QFolders!\!TXT2!.!TIME::=.!" /S /E /C /I /Q /H /R /Y >Nul 2>Nul
IF !ERRORLEVEL! EQU 0 RMDIR "!TXT1!!TXT2!" /S /Q >Nul 2>Nul
IF NOT EXIST "!TXT1!!TXT2!\" (
	<VARIABLE\SUCC SET /P SUCC=
	SET /A SUCC+=1
	>VARIABLE\SUCC ECHO !SUCC!
	IF !ACTIVESCAN! EQU 1 (
		>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(�ݸ�/���� ���� ^[Active Scan^]^)
	) ELSE (
		>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(�ݸ�/���� ����^)
	)
) ELSE (
	<VARIABLE\FAIL SET /P FAIL=
	SET /A FAIL+=1
	>VARIABLE\FAIL ECHO !FAIL!
	IF !ACTIVESCAN! EQU 1 (
		>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(���� ���� ^[Active Scan^]^)
	) ELSE (
		>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(���� ����^)
	)
)
>>DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB ECHO "!TXT1!!TXT2!\"
ENDLOCAL
GOTO :EOF

:DEL_REGK
SETLOCAL ENABLEDELAYEDEXPANSION
>VARIABLE\CHCK ECHO 1
SET TXT1=
<VARIABLE\TXT1 SET /P TXT1=
SET "TXT1TXT=!TXT1!"
SET "TXT1=!TXT1:"=\"!"
IF NOT DEFINED TXT1 (
	ENDLOCAL
	GOTO :EOF
)
SET TXT2=
<VARIABLE\TXT2 SET /P TXT2=
SET "TXT2TXT=!TXT2!"
SET "TXT2=!TXT2:"=\"!"
IF NOT DEFINED TXT2 (
	ENDLOCAL
	GOTO :EOF
)
IF "%~1" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF "%~2" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF "%~3" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF /I "%~1" == "ACTIVESCAN" (
	SET ACTIVESCAN=1
) ELSE (
	SET ACTIVESCAN=0
)
IF /I "%~2" == "BACKUP" (
	IF /I NOT "%~3" == "NULL" (
		IF NOT EXIST "!QRegistrys!\%~3_!TIME::=.!_!RANDOM!.reg" (
			REG.EXE EXPORT "!TXT1!\!TXT2!" "!QRegistrys!\%~3_!TIME::=.!_!RANDOM!.reg" /y >Nul 2>Nul
		)
	)
)
<VARIABLE\SRCH SET /P SRCH=
SET /A SRCH+=1
>VARIABLE\SRCH ECHO !SRCH!
REG.EXE DELETE "!TXT1!\!TXT2!" /f >Nul 2>Nul
IF !ERRORLEVEL! EQU 0 (
	<VARIABLE\SUCC SET /P SUCC=
	SET /A SUCC+=1
	>VARIABLE\SUCC ECHO !SUCC!
	IF !ACTIVESCAN! EQU 1 (
		>>"!QLog!" ECHO    "!TXT1TXT!\!TXT2TXT!" ^(�ݸ�/���� ���� ^[Active Scan^]^)
	) ELSE (
		>>"!QLog!" ECHO    "!TXT1TXT!\!TXT2TXT!" ^(�ݸ�/���� ����^)
	)
) ELSE (
	TOOLS\SETACL\!ARCHITECTURE!\SETACL.EXE -on "!TXT1!\!TXT2!" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -actn rstchldrn -rst "dacl,sacl" -silent >Nul 2>Nul
	TOOLS\SETACL\!ARCHITECTURE!\SETACL.EXE -on "!TXT1!\!TXT2!" -ot reg -actn clear -clr "dacl,sacl" -actn setprot -op "dacl:np;sacl:np" -rec yes -actn ace -ace "n:Administrators;p:full" -actn rstchldrn -rst "dacl,sacl" -silent >Nul 2>Nul
	REG.EXE DELETE "!TXT1!\!TXT2!" /f >Nul 2>Nul
	IF !ERRORLEVEL! EQU 0 (
		<VARIABLE\SUCC SET /P SUCC=
		SET /A SUCC+=1
		>VARIABLE\SUCC ECHO !SUCC!
		IF !ACTIVESCAN! EQU 1 (
			>>"!QLog!" ECHO    "!TXT1TXT!\!TXT2TXT!" ^(�ݸ�/���� ���� ^[Active Scan^]^)
		) ELSE (
			>>"!QLog!" ECHO    "!TXT1TXT!\!TXT2TXT!" ^(�ݸ�/���� ����^)
		)
	) ELSE (
		<VARIABLE\FAIL SET /P FAIL=
		SET /A FAIL+=1
		>VARIABLE\FAIL ECHO !FAIL!
		IF !ACTIVESCAN! EQU 1 (
			>>"!QLog!" ECHO    "!TXT1TXT!\!TXT2TXT!" ^(���� ���� ^[Active Scan^]^)
		) ELSE (
			>>"!QLog!" ECHO    "!TXT1TXT!\!TXT2TXT!" ^(���� ����^)
		)
	)
)
ENDLOCAL
GOTO :EOF

:DEL_REGV
SETLOCAL ENABLEDELAYEDEXPANSION
>VARIABLE\CHCK ECHO 1
SET TXT1=
<VARIABLE\TXT1 SET /P TXT1=
SET "TXT1TXT=!TXT1!"
SET "TXT1=!TXT1:"=\"!"
IF NOT DEFINED TXT1 (
	ENDLOCAL
	GOTO :EOF
)
SET TXT2=
<VARIABLE\TXT2 SET /P TXT2=
SET "TXT2TXT=!TXT2!"
SET "TXT2=!TXT2:"=\"!"
IF NOT DEFINED TXT2 (
	ENDLOCAL
	GOTO :EOF
)
IF "%~1" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF "%~2" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF "%~3" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF "%~4" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF /I "%~1" == "ACTIVESCAN" (
	SET ACTIVESCAN=1
) ELSE (
	SET ACTIVESCAN=0
)
IF /I "%~2" == "BACKUP" (
	IF /I NOT "%~4" == "NULL" (
		IF /I "%~3" == "RANDOM" (
			IF NOT EXIST "!QRegistrys!\%~4_!TIME::=.!_!RANDOM!.reg" (
				REG.EXE EXPORT "!TXT1!" "!QRegistrys!\%~4_!TIME::=.!_!RANDOM!.reg" /y >Nul 2>Nul
			)
		) ELSE (
			IF NOT EXIST "!QRegistrys!\%~4.reg" (
				REG.EXE EXPORT "!TXT1!" "!QRegistrys!\%~4.reg" /y >Nul 2>Nul
			)
		)
	)
)
<VARIABLE\SRCH SET /P SRCH=
SET /A SRCH+=1
>VARIABLE\SRCH ECHO !SRCH!
REG.EXE DELETE "!TXT1!" /v "!TXT2!" /f >Nul 2>Nul
IF !ERRORLEVEL! EQU 0 (
	<VARIABLE\SUCC SET /P SUCC=
	SET /A SUCC+=1
	>VARIABLE\SUCC ECHO !SUCC!
	IF !ACTIVESCAN! EQU 1 (
		>>"!QLog!" ECHO    "!TXT1TXT! : !TXT2TXT!" ^(�ݸ�/���� ���� ^[Active Scan^]^)
	) ELSE (
		>>"!QLog!" ECHO    "!TXT1TXT! : !TXT2TXT!" ^(�ݸ�/���� ����^)
	)
) ELSE (
	>VARIABLE\DENY ECHO.
	FOR /F "DELIMS=" %%V IN ('TOOLS\SETACL\!ARCHITECTURE!\SETACL.EXE -on "!TXT1!" -ot reg -actn list -lst f:tab 2^>Nul^|TOOLS\GREP\GREP.EXE [[:space:]]\{3\}deny[[:space:]]\{3\} 2^>Nul') DO (
		SET "DENY=%%V"
		SET "DENY=!DENY:   =��!"
		>>VARIABLE\DENY ECHO !DENY!
	)
	FOR /F "TOKENS=1,2 DELIMS=��" %%V IN (VARIABLE\DENY) DO (
		TOOLS\SETACL\!ARCHITECTURE!\SETACL.EXE -on "!TXT1!" -ot reg -actn trustee -trst "n1:%%V;ta:remtrst;w:dacl" -silent >Nul 2>Nul
	)
	REG.EXE DELETE "!TXT1!" /v "!TXT2!" /f >Nul 2>Nul
	IF !ERRORLEVEL! EQU 0 (
		<VARIABLE\SUCC SET /P SUCC=
		SET /A SUCC+=1
		>VARIABLE\SUCC ECHO !SUCC!
		IF !ACTIVESCAN! EQU 1 (
			>>"!QLog!" ECHO    "!TXT1TXT! : !TXT2TXT!" ^(�ݸ�/���� ���� ^[Active Scan^]^)
		) ELSE (
			>>"!QLog!" ECHO    "!TXT1TXT! : !TXT2TXT!" ^(�ݸ�/���� ����^)
		)
	) ELSE (
		<VARIABLE\FAIL SET /P FAIL=
		SET /A FAIL+=1
		>VARIABLE\FAIL ECHO !FAIL!
		IF !ACTIVESCAN! EQU 1 (
			>>"!QLog!" ECHO    "!TXT1TXT! : !TXT2TXT!" ^(���� ���� ^[Active Scan^]^)
		) ELSE (
			>>"!QLog!" ECHO    "!TXT1TXT! : !TXT2TXT!" ^(���� ����^)
		)
	)
)
ENDLOCAL
GOTO :EOF

:RESETDNS
SETLOCAL ENABLEDELAYEDEXPANSION
>VARIABLE\CHCK ECHO 1
SET TXT1=
<VARIABLE\TXT1 SET /P TXT1=
SET "TXT1TXT=!TXT1!"
SET "TXT1=!TXT1:"=\"!"
IF NOT DEFINED TXT1 (
	ENDLOCAL
	GOTO :EOF
)
SET TXT2=
<VARIABLE\TXT2 SET /P TXT2=
IF NOT DEFINED TXT2 (
	ENDLOCAL
	GOTO :EOF
)
REG.EXE ADD "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\!TXT1!" /v "NameServer" /d "" /f >Nul 2>Nul
IF !ERRORLEVEL! EQU 0 (
	IPCONFIG.EXE /REGISTERDNS >Nul 2>Nul & IPCONFIG.EXE /FLUSHDNS >Nul 2>Nul
	FOR /F "TOKENS=1,2 DELIMS=|" %%V IN ("!TXT2!") DO (
		IF NOT "%%V" == "" (
			IF NOT "%%W" == "" (
				ECHO    ������ ���� �߰ߵǾ� �ʱ�ȭ ���� ^[ Pri: %%V, Sec: %%W ^] & >>"!QLog!" ECHO    ������ ���� �߰ߵǾ� �ʱ�ȭ ���� ^[ Primary: %%V, Secondary: %%W, !TXT1TXT! ^]
			) ELSE (
				ECHO    ������ ���� �߰ߵǾ� �ʱ�ȭ ���� ^[ Pri: %%V ^] & >>"!QLog!" ECHO    ������ ���� �߰ߵǾ� �ʱ�ȭ ���� ^[ Primary: %%V, !TXT1TXT! ^]
			)
		)
	)
) ELSE (
	ECHO    ������ ���� �߰ߵǾ� �ʱ�ȭ�� �����Ͽ����� ������ �߻��߽��ϴ�. & >>"!QLog!" ECHO    ������ ���� �߰ߵǾ� �ʱ�ȭ ���� ^(���� - ���� �߻�^)
)
ENDLOCAL
GOTO :EOF

:RESETCUT
SETLOCAL ENABLEDELAYEDEXPANSION
SET TXT1=
<VARIABLE\TXT1 SET /P TXT1=
IF NOT DEFINED TXT1 (
	ENDLOCAL
	GOTO :EOF
)
SET TXT2=
<VARIABLE\TXT2 SET /P TXT2=
IF NOT DEFINED TXT2 (
	ENDLOCAL
	GOTO :EOF
)
<VARIABLE\SRCH SET /P SRCH=
SET /A SRCH+=1
>VARIABLE\SRCH ECHO !SRCH!
ATTRIB.EXE -R -H -S "!TXT1!!TXT2!" >Nul 2>Nul
COPY /Y "!TXT1!!TXT2!" "!QFiles!\!TXT2!.!TIME::=.!.vz" >Nul 2>Nul
TOOLS\SHORTCUT\SHORTCUT.EXE /A:E /F:"!TXT1!!TXT2!" /P:"" >Nul 2>Nul
IF !ERRORLEVEL! EQU 0 (
	<VARIABLE\SUCC SET /P SUCC=
	SET /A SUCC+=1
	>VARIABLE\SUCC ECHO !SUCC!
	>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(�ʱ�ȭ ����^)
) ELSE (
	<VARIABLE\FAIL SET /P FAIL=
	SET /A FAIL+=1
	>VARIABLE\FAIL ECHO !FAIL!
	>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(�ʱ�ȭ ����^)
)
ENDLOCAL
GOTO :EOF

:RESETREG
SETLOCAL ENABLEDELAYEDEXPANSION
SET TXT1=
<VARIABLE\TXT1 SET /P TXT1=
SET "TXT1TXT=!TXT1!"
SET "TXT1=!TXT1:"=\"!"
IF NOT DEFINED TXT1 (
	ENDLOCAL
	GOTO :EOF
)
SET TXT2=
<VARIABLE\TXT2 SET /P TXT2=
SET "TXT2TXT=!TXT2!"
SET "TXT2=!TXT2:"=\"!"
IF NOT DEFINED TXT2 (
	ENDLOCAL
	GOTO :EOF
)
IF "%~1" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF "%~2" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF "%~3" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF "%~4" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF /I "%3" == "BACKUP" (
	IF NOT "%~4" == "" (
		IF NOT EXIST "!QRegistrys!\%~4.reg" (
			REG.EXE EXPORT "!TXT1!" "!QRegistrys!\%~4.reg" /y >Nul 2>Nul
		)
	)
)
<VARIABLE\SRCH SET /P SRCH=
SET /A SRCH+=1
>VARIABLE\SRCH ECHO !SRCH!
>VARIABLE\DENY ECHO.
FOR /F "DELIMS=" %%V IN ('TOOLS\SETACL\!ARCHITECTURE!\SETACL.EXE -on "!TXT1!" -ot reg -actn list -lst f:tab 2^>Nul^|TOOLS\GREP\GREP.EXE [[:space:]]\{3\}deny[[:space:]]\{3\} 2^>Nul') DO (
	SET "DENY=%%V"
	SET "DENY=!DENY:   =��!"
	>>VARIABLE\DENY ECHO !DENY!
)
FOR /F "TOKENS=1,2 DELIMS=��" %%V IN (VARIABLE\DENY) DO (
	TOOLS\SETACL\!ARCHITECTURE!\SETACL.EXE -on "!TXT1!" -ot reg -actn trustee -trst "n1:%%V;ta:remtrst;w:dacl" -actn rstchldrn -rst "dacl,sacl" -silent >Nul 2>Nul
)
IF /I "%~1" == "(Default)" (
	IF /I NOT "!TXT2TXT!" == "NULL" (
		IF /I NOT "%~2" == "NULL" (
			REG.EXE ADD "!TXT1!" /ve /t "%~2" /d "!TXT2!" /f >Nul 2>Nul
		) ELSE (
			IF /I "!TXT2TXT!" == "DELETECOMMAND" (
				REG.EXE DELETE "!TXT1!" /ve /f >Nul 2>Nul
			) ELSE (
				REG.EXE ADD "!TXT1!" /ve /d "!TXT2!" /f >Nul 2>Nul
			)
		)
	) ELSE (
		REG.EXE DELETE "!TXT1!" /ve /f >Nul 2>Nul
	)
) ELSE (
	IF /I NOT "!TXT2TXT!" == "NULL" (
		IF /I NOT "%~2" == "NULL" (
			REG.EXE ADD "!TXT1!" /v "%~1" /t "%~2" /d "!TXT2!" /f >Nul 2>Nul
		) ELSE (
			IF /I "!TXT2TXT!" == "DELETECOMMAND" (
				REG.EXE DELETE "!TXT1!" /v "%~1" /f >Nul 2>Nul
			) ELSE (
				REG.EXE ADD "!TXT1!" /v "%~1" /d "!TXT2!" /f >Nul 2>Nul
			)
		)
	) ELSE (
		REG.EXE ADD "!TXT1!" /v "%~1" /d "" /f >Nul 2>Nul
	)
)
IF !ERRORLEVEL! EQU 0 (
	<VARIABLE\SUCC SET /P SUCC=
	SET /A SUCC+=1
	>VARIABLE\SUCC ECHO !SUCC!
	>>"!QLog!" ECHO    "!TXT1TXT! : %~1" ^(�ʱ�ȭ ����^)
) ELSE (
	<VARIABLE\FAIL SET /P FAIL=
	SET /A FAIL+=1
	>VARIABLE\FAIL ECHO !FAIL!
	>>"!QLog!" ECHO    "!TXT1TXT! : %~1" ^(�ʱ�ȭ ����^)
)
ENDLOCAL
GOTO :EOF

:GET_DVAL
SETLOCAL ENABLEDELAYEDEXPANSION
SET TXT1=
<VARIABLE\TXT1 SET /P TXT1=
SET "TXT1=!TXT1:\=\\!"
SET "TXT1=!TXT1:"=""!"
IF NOT DEFINED TXT1 (
	ENDLOCAL
	GOTO :EOF
)
SET TXT2=
<VARIABLE\TXT2 SET /P TXT2=
SET "TXT2=!TXT2:\=\\!"
SET "TXT2=!TXT2:"=""!"
IF NOT DEFINED TXT2 (
	ENDLOCAL
	GOTO :EOF
)
>VARIABLE\TXTX ECHO.
FOR /F "DELIMS=" %%V IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\!TXT1!\\!TXT2!\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	ENDLOCAL
	>VARIABLE\TXTX ECHO %%V
	GOTO :EOF
)
ENDLOCAL
GOTO :EOF

:P_RESULT
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\SRCH SET /P SRCH=
IF !SRCH! EQU 0 (
	ECHO    �߰ߵ��� �ʾҽ��ϴ�. & >>"!QLog!" ECHO    �߰ߵ��� ����
) ELSE (
	<VARIABLE\SUCC SET /P SUCC=
	<VARIABLE\FAIL SET /P FAIL=
	IF /I "%~1" == "RECK" (
		<VARIABLE\RECK SET /P RECK=
	)
	IF /I "%~2" == "CHKINFECT" (
		<VARIABLE\XXXX SET /P XXXX=
		IF !XXXX! EQU 0 (
			>VARIABLE\XXXX ECHO 1
			COLOR 4F
		)
	)
	IF /I "%~1" == "RECK" (
		ECHO    �߰�: !SRCH! / ����: !SUCC! / ���� ����: !FAIL! / ����� �� ��˻� �ʿ�: !RECK!
	) ELSE (
		ECHO    �߰�: !SRCH! / ����: !SUCC! / ���� ����: !FAIL!
	)
)
ENDLOCAL
GOTO :EOF

:RESETVAL
SET NUMTMP=0
SET REGTMP=NULL
SET STRTMP=NULL
>VARIABLE\CHCK ECHO 0
>VARIABLE\DENY ECHO.
>VARIABLE\FAIL ECHO 0
>VARIABLE\RECK ECHO 0
>VARIABLE\RGST ECHO.
>VARIABLE\SRCH ECHO 0
>VARIABLE\SUCC ECHO 0
>VARIABLE\TXT1 ECHO.
>VARIABLE\TXT2 ECHO.
>VARIABLE\TXTX ECHO.
IF /I "%1" == "ALL" (
	>VARIABLE\XXXX ECHO 0
	>VARIABLE\XXYY ECHO 0
)
GOTO :EOF

:END
DEL /F /Q /A DB_ACTIVE\*.DB >Nul 2>Nul & DEL /F /Q /S /A DB_EXEC\*.DB >Nul 2>Nul
ATTRIB.EXE -R -H "DB_EXEC\*" /S /D >Nul 2>Nul

IF /I NOT "%PATHDUMP%" == "NULL" SET "PATH=%PATHDUMP%"

IF %CHKEXPLORER% EQU 1 START %SYSTEMROOT%\EXPLORER.EXE >Nul 2>Nul

ECHO.

REM * Exit
IF %ERRCODE% EQU 0 (
	ECHO �� �� ���� ����Ʈ�� �غ� ���Դϴ�. â�� ���� ���ð� ��ø� ��ٷ��ּ��� ^(�� 5��^) . . .
	PING.EXE -n 5 0 >Nul 2>Nul
	START /MAX "MZK" "%QLog%" >Nul 2>Nul
	IF %AUTOMODE% NEQ 1 (
		ECHO.
		ECHO �����Ϸ��� �ƹ� Ű�� �����ʽÿ� . . .
		PAUSE >Nul 2>Nul
	)
	IF %VK% EQU 1 TOOLS\TASKS\TASKKILL.EXE /F /IM "MAGNETOK.EXE" >Nul 2>Nul
) ELSE (
	IF %AUTOMODE% EQU 1 (
		ECHO �� 10�� �Ŀ� �ڵ����� ����˴ϴ� . . .
		PING.EXE -n 10 0 >Nul 2>Nul
	) ELSE (
		ECHO �����Ϸ��� �ƹ� Ű�� �����ʽÿ� . . .
		PAUSE >Nul 2>Nul
	)
	IF %VK% EQU 1 TOOLS\TASKS\TASKKILL.EXE /F /IM "MAGNETOK.EXE" >Nul 2>Nul
)

SET ACTIVESCAN=
SET AUTOMODE=
SET CHKEXPLORER=
SET CURRENTDATE=
SET DATECHK=
SET DDRV=
SET ERRCODE=
SET NUMTMP=
SET OSVER=
SET PATHDUMP=
SET REGTMP=
SET RPTDATE=
SET STRTMP=
SET VK=

SET MZKTITLE=

SET MZKALLUSERSPROFILE=
SET MZKAPPDATA=
SET MZKCOMMONPROGRAMFILES=
SET MZKCOMMONPROGRAMFILESX86=
SET MZKLOCALAPPDATA=
SET MZKLOCALLOWAPPDATA=
SET MZKPROGRAMFILES=
SET MZKPROGRAMFILESX86=
SET MZKPUBLIC=
SET MZKSYSTEMROOT=
SET MZKUSERPROFILE=

SET YNAAA=
SET YNBBB=
SET YNCCC=

COLOR

TOOLS\TASKS\TASKKILL.EXE /F /IM "CMD.EXE" >Nul 2>Nul