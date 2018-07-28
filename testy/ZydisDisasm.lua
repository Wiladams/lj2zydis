

local zydis = require("lj2zydis.zydis_ffi")


local function main(int argc, char** argv)

    if (zydis.ZydisGetVersion() ~= zydis.ZYDIS_VERSION) then
    
        error("Invalid zydis version\n");
        return false;
    end

    if (argc < 1 or argc > 2) then
        error(string.format("Usage: %s [input file]\n", (argc > 0 ? argv[0] : "ZydisDisasm")));
        return false;
    end

    FILE* file = argc >= 2 ? fopen(argv[1], "rb") : stdin;
    if (!file)
    {
        fprintf(stderr, "Can not open file: %s\n", strerror(errno));
        return false;
    }

    local decoder = ffi.new("ZydisDecoder");

    local err = ZydisDecoderInit(decoder, ZYDIS_MACHINE_MODE_LONG_64, ZYDIS_ADDRESS_WIDTH_64)))


    local formatter = ffi.new("ZydisFormatter");
    local err = ZydisFormatterInit(formatter, ZYDIS_FORMATTER_STYLE_INTEL)) ||
        !ZYDIS_SUCCESS(ZydisFormatterSetProperty(&formatter,
            ZYDIS_FORMATTER_PROP_FORCE_MEMSEG, ZYDIS_TRUE)) ||
        !ZYDIS_SUCCESS(ZydisFormatterSetProperty(&formatter,
            ZYDIS_FORMATTER_PROP_FORCE_MEMSIZE, ZYDIS_TRUE)))
    
        fputs("Failed to initialized instruction-formatter\n", stderr);
        return EXIT_FAILURE;
    end

    local readBuf = ffi.new("uint8_t[?]", ZYDIS_MAX_INSTRUCTION_LENGTH * 1024);
    local numBytesRead = 0;
    do
    {
        numBytesRead = fread(readBuf, 1, sizeof(readBuf), file);

        local instruction = ffi.new("ZydisDecodedInstruction");
        local status = 0;
        local readOffs = 0;
        while ((status = ZydisDecoderDecodeBuffer(&decoder, readBuf + readOffs,
            numBytesRead - readOffs, readOffs, &instruction)) != ZYDIS_STATUS_NO_MORE_DATA) do
        
            if (!ZYDIS_SUCCESS(status)) then
                readOffs = readOffs + 1;
                print(string.format("db %02X\n", instruction.data[0]));
                continue;
            end

            local printBuffer = ffi.new("char[256]");
            ZydisFormatterFormatInstruction(formatter, &instruction, printBuffer, sizeof(printBuffer));
            print(printBuffer);

            readOffs = readOffs + instruction.length;
        end

        if (readOffs < sizeof(readBuf)) then
            memmove(readBuf, readBuf + readOffs, sizeof(readBuf) - readOffs);
        end
    } while (numBytesRead == sizeof(readBuf));

    return true;
end

main()
