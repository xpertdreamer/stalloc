# stalloc
Stupid memory allocator

> [!WARNING]
> May cause a lot of memory fragmentation!

## Potential API:
I think two public (linker visible) functions will be enough:

  - ``stalloc(size_in_bytes)->address``
  
  - ``frag(address)->void``

## Dependencies:
  - **fasm**
  - **gcc**

## References:
  - <https://danluu.com/malloc-tutorial/>
  - <https://bencoveney.com/posts/allocator.html>

