@ECHO OFF

PUSHD "%~dp0"

IF NOT EXIST "DB\CHECK\MZK" (
	ECHO ���� ������ �ùٸ��� ���� �� �������ֽñ� �ٶ��ϴ�.
	ECHO.
	PAUSE
	EXIT /B
)

CALL MZK VK