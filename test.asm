DATA SEGMENT
DATA ENDS

STACK SEGMENT
    DW 100 DUP (?)
STACK ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:STACK
START:  
	MOV AX,DATA
	MOV DS,AX
	CLI
	MOV AX,0
	MOV ES,AX
	MOV SI,60H*4	    ;设置中断向量
	MOV AX,offset int0
	
	MOV ES:[SI],AX
	MOV AX,CS	        ;seg int0
	MOV ES:[SI+2],AX    ;初始化8259
    MOV AL,00010011b
	MOV DX,400H
	out DX,AL
	
	MOV al,060H
	MOV DX,402H
	OUT DX,AL

	MOV al,1BH
	out DX,AL

    MOV DX,402H
    MOV AL,00H          ;OCW1,八个中断全部开放
    OUT DX,AL
        
    MOV DX,400H
    MOV AL,60H          ;OCW2,非特殊EOI结束中断
    OUT DX,AL           ;完成8259初始化


    mov dx,0800H
	IN AL,DX
    mov  dx,0600H
	OUT DX,AL
	STI

li:	
    MOV DX,400H
    MOV AL,60H          ;60H有中断向量
    OUT DX,AL
	JMP li
    
int0 proc
    CLI
	MOV DX,0800H
	IN AL,DX
    MOV DX,0600H
	OUT DX,AL
	MOV DX,400H
    MOV AL,60H
    OUT DX,AL
	STI
	IRET
int0 endp

CODE ENDS
    END START
