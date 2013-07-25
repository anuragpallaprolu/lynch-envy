  BITS 16             ;Set system to 16bit op mode


start:
	mov ax, 07c0h       ;Disk space after bootmgr. Around 4k
	add ax, 288	    ;Storing space for OS Kernel
	mov ss, ax          ;Move the segment to mount point
	mov sp, 4096        ;Move the stack pointer to 4KB Mount point.

	mov ax, 07c0h       ;Come back to the bootpoint.
	mov ds, ax          ;Start data segment to bootpoint.
	mov si, text_string	; Put string position into SI
	call print_string	; Call our string-printing routine

	jmp $			; Jump here - infinite loop!


	text_string db 'This is my cool new OS!', 0
	call print_str
	jmp $
	text_next db 'LyncheNVY Computer Corp.', 0


print_string:			; Routine: output string in SI to screen
	mov ah, 0Eh		; int 10h 'print char' function

.repeat:
	lodsb			; Get character from string
	cmp al, 0
	je print_str		; If char is zero, end of string
	int 10h			; Otherwise, print it
	jmp .repeat


.done:
	ret

print_str:
	mov ah, 0Eh

.repeat:
	lodsb
	cmp al, 0
	je .done
	int 10h
	jmp .repeat

.done:
	ret

	times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
	dw 0xAA55		; The standard PC boot signature
