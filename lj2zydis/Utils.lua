local ffi = require("ffi")

require("lj2zydis.Status")
require("lj2zydis.DecoderTypes")

ffi.cdef[[

 ZydisStatus ZydisCalcAbsoluteAddress(const ZydisDecodedInstruction* instruction,
    const ZydisDecodedOperand* operand, ZydisU64* address);

 ZydisStatus ZydisGetAccessedFlagsByAction(const ZydisDecodedInstruction* instruction,
    ZydisCPUFlagAction action, ZydisCPUFlagMask* flags);
]]

