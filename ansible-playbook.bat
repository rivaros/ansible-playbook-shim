@echo off

REM Vagrant ships a set of POSIX utils, including bash
REM And for this script environemnt contains
REM modified %Path% which contains Vagrant's bin prior to cygwin's one,
REM so call "bash" gives Vagrant's bash, not cygwin's

REM Getting bin path from cygpath which is *definitely* cygwin's or babun's bin
for /f "delims=" %%a in ('cygpath --windows /bin') do @set CYGWIN_BIN=%%a

REM Set SH to Cygwin/Babun Shell, so we get over Vagrant
set SH=%CYGWIN_BIN%\zsh.exe

echo "Windows Ansible Shim in Action..."
"%SH%" -c "ansible-playbook-shim.sh %*"
