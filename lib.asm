format ELF64

define PAGESIZE   0x1000
define HEADERSIZE 0x0020

macro sys_brk argument{
  mov rax, 12
  mov rdi, argument
  syscall
}

section '.data' writable
  current_break dq 0x00

section '.text' executable
public stalloc
; TODO: now it doesnt deal with parameter, so, need to implement that
; Parameter rdi : The amount of memory to allocate
; Return    rax : The address of start of allocated memory
stalloc:
  jmp .init
  ; add header size to requested size
  add rdi, HEADERSIZE
  ; align rdi to 8 bytes
  add rdi, 7
  and rdi, not 7
  ; TODO: check if any free block exist and ...
  ; call brk(current_break+allocation_size (for now page_size)
  lea rdi, [rax+PAGESIZE]
  sys_brk rdi
  ; if brk(heap_start+page_size) == 0 -> error
  test rax, rax
  jz .error
  ; return current_break
  mov rax, [current_break]
  add rsp, 8
  pop rbx
  ret

.init:
  push rbx
  sub rsp, 8
  ; check if requested number is greater than zero
  cmp rdi, 0
  jle .error
  ; brk(0) call to find current break
  push rdi
  sys_brk 0
  pop rdi
  ; if brk(0) == 0 -> error
  test rax, rax
  jz .error
  ; move brk(0) returned address to mem and
  mov qword [current_break], rax
  ret

.error:
  xor rax, rax
  add rsp, 8
  pop rbx
  ret
