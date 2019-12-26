;---------------------------------------------------
MShowReg8 MACRO itsName:REQ
             LOCAL tempStr
.data
tempStr BYTE "  &itsName = ",0
.code
	pushad
	MSHOWITSNAMETYPE = 0 ;; initialize TYPE to not found
	FOR reg8,<al,ah,bl,bh,cl,ch,dl,dh>
		IFIDNI <itsName>,<reg8>
			MSHOWITSNAMETYPE = 1
			movzx ecx,itsName  ;; get unsigned value
			movsx edx,itsName  ;; get signed value
    		;; Display the register or variable's name
    		push edx
    		mov  edx,OFFSET tempStr
    		call WriteString
    		pop  edx

    		mov eax,ecx         ;; get unsigned
    		mov ebx,MSHOWITSNAMETYPE
    		call WriteHexB    	;; write in hexadecimal
    		mWrite "h"
    		call Crlf
		ENDIF
	ENDM
	popad
ENDM
;---------------------------------------------------
MShowReg16 MACRO itsName:REQ
             LOCAL tempStr
.data
tempStr BYTE "  &itsName = ",0
.code
	pushad
	MSHOWITSNAMETYPE = 0 ;; initialize TYPE to not found
	FOR reg16,<ax,bx,cx,dx,si,di,bp,sp>
		IFIDNI <itsName>,<reg16>
			MSHOWITSNAMETYPE = 2
			movzx ecx,itsName  ;; get unsigned value
			movsx edx,itsName  ;; get signed value
    		;; Display the register or variable's name
    		push edx
    		mov  edx,OFFSET tempStr
    		call WriteString
    		pop  edx

    		mov eax,ecx         ;; get unsigned
    		mov ebx,MSHOWITSNAMETYPE
    		call WriteHexB    	;; write in hexadecimal
    		mWrite "h"
    		call Crlf
		ENDIF
	ENDM
	popad
ENDM
;---------------------------------------------------
MShowReg32 MACRO itsName:REQ
             LOCAL tempStr
.data
tempStr BYTE "  &itsName = ",0
.code
	pushad
	MSHOWITSNAMETYPE = 0 ;; initialize TYPE to not found
	FOR reg32,<eax,ebx,ecx,edx,esi,edi,ebp,esp>
		IFIDNI <itsName>,<reg32>
			MSHOWITSNAMETYPE = 4
      		mov   ecx,itsName  ;; get unsigned value
      		mov   edx,itsName  ;; get signed value
    		;; Display the register or variable's name
    		push edx
    		mov  edx,OFFSET tempStr
    		call WriteString
    		pop  edx

    		mov eax,ecx         ;; get unsigned
    		mov ebx,MSHOWITSNAMETYPE
    		call WriteHexB    	;; write in hexadecimal
    		mWrite "h"
    		call Crlf
		ENDIF
	ENDM
	popad
ENDM
;---------------------------------------------------
MShowAllReg MACRO
.code
	FOR reg32,<eax,ebx,ecx,edx,esi,edi,ebp,esp>
		MShowReg32 reg32
	ENDM
ENDM
;------------------------------------------------------
mReadInt MACRO varName:REQ
	push eax
	call ReadInt
	mov varName,eax
	pop  eax
ENDM
;------------------------------------------------------
mWriteInt MACRO varName:REQ
	push eax
	mov  eax,varName
	call WriteInt
	pop  eax
ENDM
;------------------------------------------------------
MShowMulRes MACRO handleSize:REQ
	push ebx
	push eax
    mWrite "MUL:"
	IF handleSize EQ 8
		movzx ebx,ax
		mov eax,ebx
    	mov ebx,2
    	;call WriteHexB
		call WriteDec
    	;mWrite "h"
		call Crlf
	ENDIF
	IF handleSize EQ 16
    	mov ebx,4
		push ax
		mov ax,dx
		rol eax,16
		;call WriteHexB
		pop ax
    	;call WriteHexB
		call WriteDec
    	;mWrite "h"
		call Crlf
	ENDIF
	IF handleSize EQ 32
		.data
		var byte 1, 4, 9, 16, 25, 36, 49, 64, 81, 100
		ind dword 0
		ans byte 65 dup(0)
		_low dword 0
		_high dword 0
		eax_quotient dword  0
		eax_remainder dword  0
		edx_quotient dword  0
		edx_remainder dword  0
		const_quotient dword 429496729
		const_remainder dword 6
		cur dword 10
		.code
		mov _low, eax
		mov _high, edx    ;save eax£¬edx in memery
	
		do_64:
	
		mov edx, 0
		mov eax, _high
		div cur
		mov [edx_remainder], edx      ;save edx's remainder
		mov [edx_quotient], eax       ;save edx's quotient
	
		mov edx, 0
		mov eax, _low
		div cur
		mov [eax_remainder], edx      ;save eax's remainder
		mov [eax_quotient], eax       ;save eax's quotient
		;call DumpRegs
	
		mov eax, const_remainder
		mul [edx_remainder]
		add eax, [eax_remainder]           ;r = remainder1 * remainder2 + remainder3 
	
		cdq
		div cur 			   ;r / 10
		inc ind                              
		mov ebx, ind
		mov [ans + ebx], dl                  ;save r % 10
	
		mov [_low], eax                     ;save r / 10
		mov [_high], 0                      ;init _high
	
		jmp go_on
	
		continue:
		jmp do_64
	
		go_on:
		mov eax, 4294967290
		mul [edx_quotient]            ;10 * quotient2 * quotient1
	
		add [_low], eax                    ;add it
		adc [_high], edx 		   ;add it
	
	
		mov eax, const_quotient		   ;quotient1 * remainder2
		mul edx_remainder
		add [_low], eax                    ;add it
		adc [_high], edx 		   ;add it
	
		mov eax, const_remainder	   ;quotient2 * remainder1
		mul edx_quotient
		add [_low], eax                    ;add it
		adc [_high], edx 		   ;add it
	
		mov eax, eax_quotient              ;quotient3	
		add [_low], eax                    ;add it	
		adc [_high], 0                     ;add it
	
		cmp _low, 0
		jz second
		jmp continue
		second: cmp _high, 0
		jnz continue
		
		mov ecx, ind
		write_it:
		movzx eax, [ans + ecx]
		call WriteDec
		loop write_it
		
		call Crlf
		pop eax
		pop ebx
	ENDIF
	pop eax
	pop ebx
ENDM
;------------------------------------------------------
MShowDivRes MACRO handleSize:REQ
	push ebx
	push eax
	IF handleSize EQ 8
		movzx ebx,al
		mov eax,ebx
    	mov ebx,1
    	mWrite "Div:"
    	;call WriteHexB
		call WriteDec
    	;mWrite "h"

    	mWrite "  Remainder:"
		;mov al,ah
		movzx ebx,ah
		mov eax,ebx
    	mov ebx,1
		call WriteDec
    	;call WriteHexB
    	;mWrite "h"

		call Crlf
	ENDIF
	IF handleSize EQ 16
		movzx ebx,ax
		mov eax,ebx
    	mov ebx,2
    	mWrite "Div:"
		call WriteDec
    	;call WriteHexB
    	;mWrite "h"

    	mWrite "  Remainder:"
		movzx ebx,dx
		mov eax,ebx
    	mov ebx,2
		call WriteDec
    	;call WriteHexB
    	;mWrite "h"

		call Crlf
	ENDIF
	IF handleSize EQ 32
    	mov ebx,4
    	mWrite "Div:"
		call WriteDec
    	;call WriteHexB
    	;mWrite "h"

    	mWrite "  Remainder:"
		mov eax,edx
		call WriteDec
    	;call WriteHexB
    	;mWrite "h"

		call Crlf
	ENDIF
	pop eax
	pop ebx
ENDM
;------------------------------------------------------
MShowCurrentTime MACRO XYPos:REQ
	.data
	sysTime SYSTEMTIME <>
	consoleHandle DWORD ?
	colonStr BYTE ":",0
	TheTimeIs BYTE "The time is ",0

	.code
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov consoleHandle,eax

	INVOKE SetConsoleCursorPosition, consoleHandle, XYPos
	INVOKE GetLocalTime,ADDR sysTime

	mov   edx,OFFSET TheTimeIs		; "The time is "
	call  WriteString

	movzx eax,sysTime.wHour			; hours
	call  WriteDec
	mov   edx,offset colonStr		; ":"
	call  WriteString
	movzx eax,sysTime.wMinute		; minutes
	call  WriteDec
	call  WriteString				; ":"
	movzx eax,sysTime.wSecond		; seconds
	call  WriteDec
	call Crlf	
ENDM