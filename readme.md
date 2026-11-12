# wasmtime-gd (and lua-boxes-gd for now)

This repo contains the sources for the wasmtime-gd extension by @Avril112113  
It was created as no other gdextensions supported WASM exceptions and none looked actively maintained.  

This gdextension is **WORK IN PROGRESS!** but it does work as demonstrated by the execution of Lua5.4 within WASM.  

Notable features;
- Run WASM or WAT using wasmtime.
- Supports WASM exceptions.
- GDScript side wasi preview1 implementation.
- Nearly every method is documented.
- Better safety with Rust *(though @Avril112113 is no expert in Rust)*

What is not included;
- No wasi components *(not planned)*
- No threading support *(can be called from other threads, but only one thread can access the store at a time)*
- Missing unit tests... This is planned.
- No sandbox is completely secure, use this library at your own risk.  
  If you find a security issue, please make a GitHub issue!  
  There is no official channel for responsible disclosure currently.  

## AI Disclosure
AI has been used for code quality and verification.  
Some small sections may have been AI generated code.  
The overwhelming majority of the code is manually written and everything is reviewed.  
**PR's and issues must follow the principles above.**  
