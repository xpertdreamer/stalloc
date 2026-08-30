format ELF64

public stalloc

macro call_brk argument{
  mov rax, 12
  mov rdi, argument
  syscall
}

define PAGESIZE 0x1000

section '.data' writable
  first_alloc dq 0x00

section '.text' executable

stalloc:
  push rdi
  call_brk 0
  pop rdi

  test rax, rax
  jz .error

  mov qword [first_alloc], rax
  lea rdi, [rax+PAGESIZE]
  call_brk rdi

  test rax, rax
  jz .error

  mov rax, [first_alloc]
  ret
.error:
  xor rax, rax
  ret
