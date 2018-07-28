local ffi = require("ffi")

require("lj2zydis.CommonTypes")
require("lj2zydis.String")
require("lj2zydis.EnumMnemonic")


ffi.cdef[[
 const char* ZydisMnemonicGetString(ZydisMnemonic mnemonic);
 const ZydisStaticString* ZydisMnemonicGetStaticString(ZydisMnemonic mnemonic);
]]

