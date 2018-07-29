package.path = "../?.lua;"..package.path

local ffi = require("ffi")
local bit = require("bit")

local zydis = require("lj2zydis.zydis")

local sizeOfCode = 64;
local data = ffi.new("uint8_t[64]",
{
    0x0E,0x1F,0xBA,0x0E,0x00,0xB4,0x09,0xCD,0x21,0xB8,0x01,0x4C,0xCD,0x21,0x54,0x68,
    0x69,0x73,0x20,0x70,0x72,0x6F,0x67,0x72,0x61,0x6D,0x20,0x63,0x61,0x6E,0x6E,0x6F,
    0x74,0x20,0x62,0x65,0x20,0x72,0x75,0x6E,0x20,0x69,0x6E,0x20,0x44,0x4F,0x53,0x20,
    0x6D,0x6F,0x64,0x65,0x2E,0x0D,0x0D,0x0A,0x24,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
});



local function main()

    local decoder = ffi.new("ZydisDecoder");
    -- in order to decode the DOS stub at the beginning of a PE
    -- formatted file, ZYDIS_ADDRESS_WIDTH_16 must be used
    local err = zydis.ZydisDecoderInit(decoder, ffi.C.ZYDIS_MACHINE_MODE_LEGACY_32, ffi.C.ZYDIS_ADDRESS_WIDTH_16)


    local formatter = ffi.new("ZydisFormatter");
    local err = zydis.ZydisFormatterInit(formatter, ffi.C.ZYDIS_FORMATTER_STYLE_INTEL)
    
    local offset = 0
    local length = sizeOfCode;
    local instructionPointer = 0x0000000000000000ULL;
    local instruction = ffi.new("ZydisDecodedInstruction");
    local buffer = ffi.new("uint8_t[256]");

    while (zydis.ZydisDecoderDecodeBuffer(
        decoder, data + offset, length - offset,
        instructionPointer, instruction) == 0) do
        
        -- Print current instruction pointer.
        io.write(string.format("0x%s  ", bit.tohex(instructionPointer)));

        -- Format & print the binary instruction
        -- structure to human readable format.
        zydis.ZydisFormatterFormatInstruction(formatter, instruction, buffer, 256);
        print(ffi.string(buffer));

        offset = offset+instruction.length;
        instructionPointer = instructionPointer + instruction.length;
    end

    print("DONE")
    return true;
end

main()
