package.path = "../?.lua;"..package.path

local ffi = require("ffi")
local bit = require("bit")

local zydis = require("lj2zydis.zydis")

local sizeOfCode = 25;
local data = ffi.new("uint8_t[25]",
{
    0x51, 0x8D, 0x45, 0xFF, 0x50, 0xFF, 0x75, 0x0C, 0xFF, 0x75,
    0x08, 0xFF, 0x15, 0xA0, 0xA5, 0x48, 0x76, 0x85, 0xC0, 0x0F,
    0x88, 0xFC, 0xDA, 0x02, 0x00
});

--[[
007FFFFFFF400000   push rcx
007FFFFFFF400001   lea eax, [rbp-0x01]
007FFFFFFF400004   push rax
007FFFFFFF400005   push qword ptr [rbp+0x0C]
007FFFFFFF400008   push qword ptr [rbp+0x08]
007FFFFFFF40000B   call [0x008000007588A5B1]
007FFFFFFF400011   test eax, eax
007FFFFFFF400013   js 0x007FFFFFFF42DB15
]]


local function main()

    local decoder = zydis.ZydisDecoder(ffi.C.ZYDIS_MACHINE_MODE_LONG_64, ffi.C.ZYDIS_ADDRESS_WIDTH_64);   -- ffi.new("ZydisDecoder");
    local formatter = zydis.ZydisFormatter();
     
    local offset = 0
    local length = sizeOfCode;
    local instructionPointer = 0x007FFFFFFF400000ULL;
    local instruction = ffi.new("ZydisDecodedInstruction");
    local buffer = ffi.new("uint8_t[256]");

    while (decoder:DecodeBuffer(data + offset, length - offset,instructionPointer, instruction)) do
        -- Print current instruction pointer.
        io.write(string.format("0x%s  ", bit.tohex(instructionPointer)));

        -- Format & print the binary instruction
        -- structure to human readable format.
        formatter:FormatInstruction(instruction, buffer, 256);
        print(ffi.string(buffer));

        offset = offset+instruction.length;
        instructionPointer = instructionPointer + instruction.length;
    end

    return true;
end

main()
