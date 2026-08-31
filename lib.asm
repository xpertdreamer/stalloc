format ELF64

define PAGESIZE 0x1000

macro sys_brk argument{
  mov rax, 12
  mov rdi, argument
  syscall
}

section '.data' writable
  current_break dq 0x00

section '.text' executable
public stalloc
; Parameter rdi : The amount of memory to allocate
; Return    rax : The address of start of allocated memory
stalloc:
  push rbx
  sub rsp, 8
  ; check if requested number is greater than zero
  cmp rdi, 0
  jle .error
  ; brk(0) call to find heap start
  push rdi
  sys_brk 0
  pop rdi
  ; if brk(0) == 0 -> error
  test rax, rax
  jz .error
  ; mov brk(0) returned address to mem and call brk(heap_start+allocation_size)
  mov qword [current_break], rax
  lea rdi, [rax+PAGESIZE]
  sys_brk rdi
  ; if brk(heap_start+page_size) == 0 -> error
  test rax, rax
  jz .error
  ; return heap_start
  mov rax, [current_break]
  add rsp, 8
  pop rbx
  ret

.error:
  xor rax, rax
  ret
