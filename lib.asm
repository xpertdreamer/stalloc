format ELF64

define PAGESIZE   0x1000
define HEADERSIZE 0x0018

define HEADER_FLAG 0x0000
define HEADER_SIZE 0x0008
define HEADER_NEXT 0x0010

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
  push rbx
  push rdx

  ; check if requested number is greater than zero
  cmp rdi, 0
  jle .error

  ; save rdi
  mov rbx, rdi

  ; brk(0) call to find current break
  sys_brk 0
  ; if brk(0) != 0 -> error
  cmp rax, -1
  je .error

  ; check if current_break == 0 -> move brk(0) returned address to mem
  cmp qword [current_break], 0
  jne .skip_init
  mov [current_break], rax

.skip_init:
  ; save old break to return
  mov r8, [current_break]

  ; add size of header & align rdi to 8 bytes
  lea rdi, [rbx + HEADERSIZE + 7]
  and rdi, not 7


  ; start of new adress calculation
  ; allocation_size = (size + PAGESIZE - 1) / PAGESIZE
  mov rax, rdi
  add rax, PAGESIZE
  dec rax
  xor rdx, rdx
  mov rbx, PAGESIZE
  div rbx
  mov rcx, rax
  ; get expansion size
  imul rcx, PAGESIZE

  ; TODO: write information to the header to properly handle new allocations
  ; TODO: check if any free block exist and ...
  ; call brk(current_break+allocation_size (for now page_size*n, where n=number of pages needed)
  add rcx, [current_break]
  sys_brk rcx

  ; if brk(heap_start+page_size) != 0 -> error
  cmp rax, -1
  je .error

  ; return old break
  mov [current_break], rax

  call .set_header

  mov rax, r8
  pop rdx
  pop rbx
  ret

.set_header:
  mov r9, [current_break]
  sub r9, HEADERSIZE
  mov qword [r9+HEADER_FLAG], 1
  mov qword [r9+HEADER_SIZE], rbx
  ; mov qword [r9+HEADER_NEXT], next_block
  ret

.error:
  xor rax, rax
  pop rdx
  pop rbx
  ret
