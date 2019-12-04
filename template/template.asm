;.386
;.model flat,stdcall
option casemap:none
 
;导入Lib库
includelib kernel32.Lib
includelib User32.Lib
includelib Irvine32.Lib
include Irvine32.inc
 
;声明函数原型
;ExitProcess proto,dwExitCode:dword
 
;代码段
.code
main:
        call Crlf
        call WaitMsg
        ;invoke ExitProcess,0
        exit
end main