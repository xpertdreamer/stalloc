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
  ; according to abi we need to save rbx
  mov r8, rdi
  ; check if requested number is greater than zero
  cmp rdi, 0
  jle .error
  ; brk(0) call to find current break
  sys_brk 0
  ; if brk(0) != 0 -> error
  cmp rax, -1
  je .error
  ; check if current_break == 0 -> move brk(0) returned address to mem and
  cmp qword [current_break], 0
  jne .skip_init
  mov [current_break], rax
.skip_init:
  mov r9, [current_break]
  mov rdi, r8
  ; add header size to requested size
  add rdi, HEADERSIZE
  ; align rdi to 8 bytes
  add rdi, 7
  and rdi, not 7
  ; TODO: check if any free block exist and ...
  ; call brk(current_break+allocation_size (for now page_size)
  mov rdi, [current_break]
  add rdi, PAGESIZE
  sys_brk rdi
  ; if brk(heap_start+page_size) != 0 -> error
  cmp rax, -1
  je .error
  ; return current_break
  mov [current_break], rax
  mov rax, r9
  ret

.error:
  xor rax, rax
  ret
