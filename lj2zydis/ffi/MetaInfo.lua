
local ffi = require("ffi")


require("lj2zydis.ffi.CommonTypes")

require("lj2zydis.ffi.EnumInstructionCategory")
require("lj2zydis.ffi.EnumISASet")
require("lj2zydis.ffi.EnumISAExt")

ffi.cdef[[
const char* ZydisCategoryGetString(ZydisInstructionCategory category);
const char* ZydisISASetGetString(ZydisISASet isaSet);
const char* ZydisISAExtGetString(ZydisISAExt isaExt);
]]


