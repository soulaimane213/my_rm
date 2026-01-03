section .data

	v_flag_str db "-v" , 0
	i_flag_str db "-i" , 0
	usage_msg db "the usage: ./rm <file1> <file2>...", 0
	usage_msg_len equ $ - usage_msg
	deleted_msg db "deleted :", 0
	deleted_msg_len equ $ - deleted_msg
	fstat_fail_msg db "fstat fail", 0
	fstat_fail_len equ $ - 	fstat_fail_msg
	newline db 10
	question_msg db "do you to delete this :" , 0
	question_msg_len equ $ - question_msg
	
extern strlen
extern strcmp

section .bss
	response resb 2
	v_flag resb 1
	i_flag resb 1



section .text
global _start
_start:
	
	mov rdi , [rsp] ; the argc
	lea rsi , [rsp + 16] ; the argv
	cmp rdi , 1
	je print_usage
	call main

;########### main fucntion  ##############
main:
	push rbp
	mov rbp , rsp
	sub rsp  , 208 ; big value for saving strcut info
	
	mov [rbp - 8] , rdi ; saving the argc 
	mov [rbp - 16] , rsi ; saving the argv
	
	;setting argument for check_flag fucntion 
	mov rdi , [rbp - 8]  ; passing the argc
	mov rsi , [rbp - 16] ; passing the argv
	call check_flags
	 
	mov r12 , [rbp - 16]
	imul rax , rax , 8
	add r12 , rax
	
delete_loop:
	mov rax , [r12]
	cmp rax , 0
	je delete_end
	;call newfstat syscall 
	mov rax , 262
	mov rdi , -100
	mov rsi , [r12]
	lea rdx , [rsp + 48 ]
	mov r10 , 0x100 ; wich mean dotn follow any symlink like lstat
	syscall
	cmp rax , 0
	jne print_error
	mov eax ,dword [rdx + 24]
	and rax , 0xF000
	cmp rax , 0x8000 ; this for a file 
	je this_is_file
	cmp rax , 0x4000
	je this_is_dir


;###### deletign the files ########


this_is_dir:
	cmp byte [i_flag] , 1
	je call_check_answear_dir
	jmp delete_dir
	
call_check_answear_dir:
	call check_answear
	cmp rax , 1
	je delete_dir
	jmp skip_delete


delete_dir:
	mov rax , 84
	mov rdi , [r12]
	syscall
	cmp byte [v_flag] , 1
	je print_deleted
	jmp skip_delete



;###### deletign the files ########


this_is_file:
	cmp byte [i_flag] , 1
	je call_chek_answear_file
	jmp delete_file 	

call_chek_answear_file:
	call check_answear
	cmp rax , 1
	je delete_file
	jmp skip_delete

delete_file:
	mov rax , 87
	mov rdi , [r12]
	syscall
	cmp byte [v_flag] , 1
	je print_deleted
	jmp skip_delete



print_deleted:
	
	mov rax , 1
	mov rdi , 1
	mov rsi , deleted_msg
	mov rdx , deleted_msg_len
	syscall

	mov rdi , [r12]
	call strlen
	mov rdx , rax
	;prin the name of the element deleted
	mov rax , 1
	mov rdi , 1
	mov rsi , [r12]
	;rdx has already the len
	syscall
	
	;prin new _line 
	mov rax , 1
	mov rdi , 1
	mov rsi , newline
	mov rdx , 1
	syscall 
	


skip_delete:
	; increment the r12 and jmp again to the loop
	add r12 , 8
	jmp delete_loop


delete_end:
	jmp program_end


print_error:
	mov rax , 1
	mov rdi , 1
	mov rsi , fstat_fail_msg
	mov rdx , fstat_fail_len
	syscall
	jmp skip_delete

print_usage:
	mov rax , 1
	mov rdi , 1
	mov rsi , usage_msg
	mov rdx , usage_msg_len
	syscall


program_end:
	mov rax , 60
	mov rdi , 0
	syscall












;#########" check_answear_fucntion #############"
check_answear:
	
	;question msg
	mov rax , 1
	mov rdi , 1
	mov rsi , question_msg
	mov rdx , question_msg_len
	syscall

	mov rdi , [r12]
	call strlen
	mov rdx , rax
	
	;print program_name
	mov rax , 1
	mov rdi , 1
	mov rsi , [r12]
	; rdx already set to len
	syscall

	mov rax , 1
	mov rdi , 1
	mov rsi , newline
	mov rdx , 1
	syscall	


	;get the answear
	mov rax , 0
	mov rdi , 0
	mov rsi , response
	mov rdx , 2
	syscall

	cmp byte [response] , 'y'
	je set_rax_1
	jmp set_rax_0	

set_rax_1:
	mov rax , 1
	jmp check_answear_end

set_rax_0:
	mov rax , 0
	jmp check_answear_end

check_answear_end:
	ret




;#########" check_flag fcuntion ##########
check_flags:

	push rbp
	mov rbp , rsp
	sub rsp , 48
	
	mov [rbp - 8]  , rdi ; argc
	mov [rbp - 16] , rsi ; argv
	
	mov r14 , 0
	mov r12 , [rbp - 16]
	mov r9 , [rbp - 8]

check_loop:
	cmp r14 , r9
	je check_done
	
	mov rdi , [r12]
	mov rsi , i_flag_str
	call strcmp
	cmp rax, 0
	je set_i_flag


	mov rdi , [r12]
	mov rsi , v_flag_str
	call strcmp
	cmp rax , 0
	je set_v_flag
	jmp check_done 



set_i_flag:
	
	mov byte [i_flag] , 1
	inc r14
	add r12 , 8
	jmp check_loop

set_v_flag:
	
	mov byte [v_flag] , 1
	inc r14
	add r12 , 8
	jmp check_loop



check_done:
	mov rax , r14
	add rsp , 48
	pop rbp
	ret


