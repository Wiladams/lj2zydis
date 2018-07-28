
local ffi = require("ffi")


require("lj2zydis.CommonTypes")
require("lj2zydis.Status")
--require("lj2zydis.LibC.h>


ffi.cdef[[

typedef struct ZydisString_
{
    char* buffer;
    ZydisUSize length;
    ZydisUSize capacity;
} ZydisString;
]]

--#pragma pack(push, 1)

ffi.cdef[[
typedef struct ZydisStaticString_
{
    const char* buffer;
    ZydisU8 length;
} ZydisStaticString __attribute__((__packed__));
]]
--]]..(ffi.arch == "x64" and [[__attribute__((__packed__));]] or [[;]]))
--#pragma pack(pop)

ffi.cdef[[

typedef ZydisU8 ZydisLetterCase;


enum ZydisLetterCases
{
    ZYDIS_LETTER_CASE_DEFAULT,
    ZYDIS_LETTER_CASE_LOWER,
    ZYDIS_LETTER_CASE_UPPER,
    ZYDIS_LETTER_CASE_MAX_VALUE = ZYDIS_LETTER_CASE_UPPER
};
]]


--[[

#define ZYDIS_MAKE_STRING(string) \
    { (char*)string, sizeof(string) - 1, sizeof(string) - 1 }


#define ZYDIS_MAKE_STATIC_STRING(string) \
    { string, sizeof(string) - 1 }
--]]

ffi.cdef[[
 ZydisStatus ZydisStringInit(ZydisString* string, char* text);
 ZydisStatus ZydisStringFinalize(ZydisString* string);
 ZydisStatus ZydisStringAppend(ZydisString* string, const ZydisString* text);
 ZydisStatus ZydisStringAppendEx(ZydisString* string, const ZydisString* text,ZydisLetterCase letterCase);

 ZydisStatus ZydisStringAppendC(ZydisString* string, const char* text);

 ZydisStatus ZydisStringAppendExC(ZydisString* string, const char* text,
    ZydisLetterCase letterCase);

 ZydisStatus ZydisStringAppendStatic(ZydisString* string,
    const ZydisStaticString* text, ZydisLetterCase letterCase);

 ZydisStatus ZydisStringAppendExStatic(ZydisString* string,
    const ZydisStaticString* text, ZydisLetterCase letterCase);

 ZydisStatus ZydisStringAppendDecU(ZydisString* string, ZydisU64 value,
    ZydisU8 paddingLength);

 ZydisStatus ZydisStringAppendDecS(ZydisString* string, ZydisI64 value,
    ZydisU8 paddingLength);

 ZydisStatus ZydisStringAppendHexU(ZydisString* string, ZydisU64 value,
    ZydisU8 paddingLength, ZydisBool uppercase, const ZydisString* prefix,
    const ZydisString* suffix);

 ZydisStatus ZydisStringAppendHexS(ZydisString* string, ZydisI64 value,
    ZydisU8 paddingLength, ZydisBool uppercase, const ZydisString* prefix,
    const ZydisString* suffix);
]]

