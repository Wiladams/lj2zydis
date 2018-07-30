local ffi = require("ffi")

require("lj2zydis.ffi.CommonTypes")
require("lj2zydis.ffi.String")
require("lj2zydis.ffi.EnumMnemonic")


ffi.cdef[[
 const char* ZydisMnemonicGetString(ZydisMnemonic mnemonic);
 const ZydisStaticString* ZydisMnemonicGetStaticString(ZydisMnemonic mnemonic);
]]

