local ffi = require("ffi")

require("lj2zydis.ffi.String")
require("lj2zydis.ffi.CommonTypes")
require("lj2zydis.ffi.EnumRegister")


ffi.cdef[[
typedef ZydisU8 ZydisRegisterClass;

enum ZydisRegisterClasses
{
    ZYDIS_REGCLASS_INVALID,
    ZYDIS_REGCLASS_GPR8,
    ZYDIS_REGCLASS_GPR16,
    ZYDIS_REGCLASS_GPR32,
    ZYDIS_REGCLASS_GPR64,
    ZYDIS_REGCLASS_X87,
    ZYDIS_REGCLASS_MMX,
    ZYDIS_REGCLASS_XMM,
    ZYDIS_REGCLASS_YMM,
    ZYDIS_REGCLASS_ZMM,
    ZYDIS_REGCLASS_FLAGS,
    ZYDIS_REGCLASS_IP,
    ZYDIS_REGCLASS_SEGMENT,
    ZYDIS_REGCLASS_TEST,
    ZYDIS_REGCLASS_CONTROL,
    ZYDIS_REGCLASS_DEBUG,
    ZYDIS_REGCLASS_MASK,
    ZYDIS_REGCLASS_BOUND,

    ZYDIS_REGCLASS_MAX_VALUE = ZYDIS_REGCLASS_BOUND
};
]]

ffi.cdef[[
 typedef ZydisU16 ZydisRegisterWidth;
]]

ffi.cdef[[
 ZydisRegister ZydisRegisterEncode(ZydisRegisterClass registerClass, ZydisU8 id);
 ZydisI16 ZydisRegisterGetId(ZydisRegister reg);
 ZydisRegisterClass ZydisRegisterGetClass(ZydisRegister reg);
 ZydisRegisterWidth ZydisRegisterGetWidth(ZydisRegister reg);
 ZydisRegisterWidth ZydisRegisterGetWidth64(ZydisRegister reg);
 const char* ZydisRegisterGetString(ZydisRegister reg);
 const ZydisStaticString* ZydisRegisterGetStaticString(ZydisRegister reg);

]]
