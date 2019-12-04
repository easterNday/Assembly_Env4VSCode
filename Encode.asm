option casemap:none
 
;导入Lib库
includelib kernel32.Lib
includelib User32.Lib
includelib Irvine32.Lib
include Irvine32.inc
 
 .data
 Msg BYTE "HELLO,WORLD!",0
 
;代码段
.code
main:
        MOV EDX,OFFSET Msg
        call WriteString
        call Crlf
        call WaitMsg
        ;invoke ExitProcess,0
        exit
end main