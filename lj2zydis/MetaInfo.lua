
local ffi = require("ffi")


require("lj2zydis.CommonTypes")

require("lj2zydis.EnumInstructionCategory")
require("lj2zydis.EnumISASet")
require("lj2zydis.EnumISAExt")

ffi.cdef[[
const char* ZydisCategoryGetString(ZydisInstructionCategory category);
const char* ZydisISASetGetString(ZydisISASet isaSet);
const char* ZydisISAExtGetString(ZydisISAExt isaExt);
]]


