local ffi = require("ffi")

ffi.cdef[[
    typedef uint8_t   ZydisU8;
    typedef uint16_t  ZydisU16;
    typedef uint32_t  ZydisU32;
    typedef uint64_t  ZydisU64;
    typedef int8_t    ZydisI8;
    typedef int16_t   ZydisI16;
    typedef int32_t   ZydisI32;
    typedef int64_t   ZydisI64;
    typedef size_t    ZydisUSize;
    typedef ptrdiff_t ZydisISize;
    typedef uintptr_t ZydisUPointer;
    typedef intptr_t  ZydisIPointer;

    typedef ZydisU8 ZydisBool;

]]
