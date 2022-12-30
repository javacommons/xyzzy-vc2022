@echo off
setlocal
cd /d %~dp0

echo Byte compile...
rem startup.lc �����u���݂���t�@�C�����쐬���邱�Ƃ͏o���܂���v�ƌ�����
rem ���܂ɃG���[�ɂȂ�̂ō폜
del /S /Q lisp\startup.lc >nul 2>&1

del /S /Q xyzzy.wxp >nul 2>&1
set XYZZYHOME=%~dp0
set XYZZYINIFILE=
set XYZZYCONFIGPATH=
xyzzy.exe -q -trace -load misc/makelc.l -e "(makelc:makelc-and-exit t)"
if not %ERRORLEVEL%==0 goto error
del /S /Q xyzzy.wxp 2> nul
goto :eof

:error
echo Byte compile error!
exit /b 1
