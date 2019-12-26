;.386
;.model flat,stdcall
option casemap:none
 
;导入Lib库
includelib kernel32.Lib
includelib User32.Lib
includelib Irvine32.Lib
include Irvine32.inc
include Macros.inc	;使用本书的宏库
include MePass.inc

.data
hello DWORD ?
dividend QWORD 0000000800300020H
divisor DWORD 00000100H
XYPos COORD <10,5>

.code

main PROC
	;输出寄存器
	MOV EAX,12345678H
	MShowReg8 Al
	MShowReg16 AX
	MShowReg32 EAX
	MShowAllReg
	call Crlf

	;读取输出
	mReadInt hello
	mWriteInt hello
	call Crlf

	;乘法
	mov al,5h
	mov bl,10h
	MUL bl
	MShowMulRes 8
	mov ax,2000h
	mov bx,0100h
	MUL bx
	MShowMulRes 16
	mov eax,12345h
	mov ebx,10000h
	MUL ebx
	MShowMulRes 32

	;除法
	mov ax,0083h
	mov bl,2
	div bl
	MShowDivRes 8
	mov ax,8003h
	mov cx,100h
	div cx
	MShowDivRes 16
	mov edx,DWORD PTR dividend+4
	MOV EAX,DWORD PTR dividend
	DIV divisor
	MShowDivRes 32

	;MShowCurrentTime XYPos

	exit
main ENDP
END main