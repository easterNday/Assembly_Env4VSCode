.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword
option casemap :none   ;去掉大小写敏感

include windows.inc
include user32.inc
includelib user32.lib
include kernel32.inc
includelib kernel32.lib

.data

szCaption db 'Win32 Example',0
szText db 'Win32 Assembly, Simple and powerful!',0

.code
main proc
	invoke MessageBox,NULL,offset szText,offset szCaption,MB_OK
	invoke ExitProcess,0
main endp
end main