# stalloc
Stupid memory allocator

> [!WARNING]
> May cause a lot of memory fragmentation!

## Potential API:
I think two public (linker visible) functions will be enough:

  - ``stalloc(size_in_bytes) -> address``
  
  - ``frag(address) -> void``

## Dependencies:
  - **fasm**
  - **gcc**

## References:
  - <https://danluu.com/malloc-tutorial/>
  - <https://bencoveney.com/posts/allocator.html>

## TODO: 
_(RULE1)_ If it`s first allocation -> check the size of requested memory:

  1. If < PAGESIZE -> request to move break point on one PAGE_SIZE and deal with this memory
  2. If > PAGESIZE -> calculate 

_(RULE2)_ If not, search for free block. If free blocks doesn`t exist -> expand heap according to RULE1

_(RULE3)_ After each useful block should exist one 32-byte meta header, that contains some useful data about current block and ptr to the next block.

_(RULE4)_ I don't care about memory fragmentation and other blah-blah-blah stuff. Common it's recreational-learning project, I`m not a professor.
