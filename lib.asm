format ELF64

define PAGESIZE   0x1000
define HEADERSIZE 0x0018

define HEADER_FLAG 0x0000 ; 0 - free, 1 - in-use
define HEADER_SIZE 0x0008
define HEADER_NEXT 0x0010 ; address

macro sys_brk argument{
  mov rax, 12
  mov rdi, argument
  syscall
}

section '.data' writable
  heap_start dq 0x00
  current_break dq 0x00

section '.text' executable
public stalloc
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

  ; check if current_break == 0 -> move brk(0) returned address to mem
  cmp qword [current_break], 0
  jne .skip_init

  ; brk(0) call to find current break
  sys_brk 0
  ; if brk(0) == -1 -> error
  cmp rax, -1
  je .error
  mov [current_break], rax
  mov [heap_start], rax


.skip_init:
  ; save old break to return
  mov r8, [current_break]

  ; add size of header & align rdi to 8 bytes
  lea rdi, [rbx + HEADERSIZE + 7]
  and rdi, not 7

  ; TODO: check if any free block exist and place new block in first found spot
  ; call .find_free

.no_free_blocks:
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
  ; call brk(current_break+allocation_size (for now page_size*n, where n=number of pages needed)
  mov rbx, rcx
  add rcx, [current_break]
  sys_brk rcx

  ; if brk(heap_start+page_size) != 0 -> error
  cmp rax, -1
  je .error

  ; save meta in header
  mov qword [r8+HEADER_FLAG], 1
  mov qword [r8+HEADER_SIZE], rbx
  ; find next block
  ; push rax
  ; call .find_next
  mov qword [r8+HEADER_NEXT], rax ; temporary, while allocating one page each call

  ; return pointer to data block (right after header)
  ; pop rax
  mov [current_break], rax
  lea rax, [r8+HEADERSIZE]

; .find_next:
;   ret

;.find_free:
;  ret

.success:
  pop rdx
  pop rbx
  ret

.error:
  xor rax, rax
  pop rdx
  pop rbx
  ret
