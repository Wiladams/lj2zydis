
local ffi = require("ffi")


require("lj2zydis.CommonTypes")
require("lj2zydis.Status")
--require("lj2zydis.LibC.h>


ffi.cdef[[
/**
 * @brief   Defines the `ZydisString` struct.
 */
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
/**
 * @brief   Defines the `ZydisLetterCase` datatype.
 */
typedef ZydisU8 ZydisLetterCase;

/**
 * @brief   Values that represent letter cases.
 */
enum ZydisLetterCases
{

    ZYDIS_LETTER_CASE_DEFAULT,

    ZYDIS_LETTER_CASE_LOWER,

    ZYDIS_LETTER_CASE_UPPER,

    ZYDIS_LETTER_CASE_MAX_VALUE = ZYDIS_LETTER_CASE_UPPER
};
]]


--[[
/**
 * @brief   Creates a `ZydisString` struct from a static C-string.
 *
 * @param   string  The C-string constant.
 */
#define ZYDIS_MAKE_STRING(string) \
    { (char*)string, sizeof(string) - 1, sizeof(string) - 1 }

/**
 * @brief   Creates a `ZydisStaticString` from a static C-string.
 *
 * @param   string  The C-string constant.
 */
#define ZYDIS_MAKE_STATIC_STRING(string) \
    { string, sizeof(string) - 1 }
--]]

ffi.cdef[[
/**
 * @brief   Initializes a `ZydisString` struct with a C-string.
 *
 * @param   string  The string to initialize.
 * @param   text    The C-string constant.
 *
 * @return  A zydis status code.
 */
 ZydisStatus ZydisStringInit(ZydisString* string, char* text);

/**
 * @brief   Finalizes a `ZydisString` struct by adding a terminating zero byte.
 *
 * @param   string  The string to finalize.
 *
 * @return  A zydis status code.
 */
 ZydisStatus ZydisStringFinalize(ZydisString* string);

/* ---------------------------------------------------------------------------------------------- */

/**
 * @brief   Appends a `ZydisString` to another `ZydisString`.
 *
 * @param   string      The string to append to.
 * @param   text        The string to append.
 *
 * @return  @c ZYDIS_STATUS_SUCCESS, if the function succeeded, or
 *          @c ZYDIS_STATUS_INSUFFICIENT_BUFFER_SIZE, if the size of the buffer was not
 *          sufficient to append the given @c text.
 */
 ZydisStatus ZydisStringAppend(ZydisString* string, const ZydisString* text);

/**
 * @brief   Appends a `ZydisString` to another `ZydisString`, converting it to the specified
 *          letter-case.
 *
 * @param   string      The string to append to.
 * @param   text        The string to append.
 * @param   letterCase  The letter case to use.
 *
 * @return  @c ZYDIS_STATUS_SUCCESS, if the function succeeded, or
 *          @c ZYDIS_STATUS_INSUFFICIENT_BUFFER_SIZE, if the size of the buffer was not
 *          sufficient to append the given @c text.
 */
 ZydisStatus ZydisStringAppendEx(ZydisString* string, const ZydisString* text,
    ZydisLetterCase letterCase);

/**
 * @brief   Appends the given C-string to a `ZydisString`.
 *
 * @param   string      The string to append to.
 * @param   text        The C-string to append.
 *
 * @return  @c ZYDIS_STATUS_SUCCESS, if the function succeeded, or
 *          @c ZYDIS_STATUS_INSUFFICIENT_BUFFER_SIZE, if the size of the buffer was not
 *          sufficient to append the given @c text.
 */
 ZydisStatus ZydisStringAppendC(ZydisString* string, const char* text);

/**
 * @brief   Appends the given C-string to a `ZydisString`, converting it to the specified
 *          letter-case.
 *
 * @param   string      The string to append to.
 * @param   text        The C-string to append.
 * @param   letterCase  The letter case to use.
 *
 * @return  @c ZYDIS_STATUS_SUCCESS, if the function succeeded, or
 *          @c ZYDIS_STATUS_INSUFFICIENT_BUFFER_SIZE, if the size of the buffer was not
 *          sufficient to append the given @c text.
 */
 ZydisStatus ZydisStringAppendExC(ZydisString* string, const char* text,
    ZydisLetterCase letterCase);

/**
 * @brief   Appends the given 'ZydisStaticString' to a `ZydisString`.
 *
 * @param   string      The string to append to.
 * @param   text        The static-string to append.
 *
 * @return  @c ZYDIS_STATUS_SUCCESS, if the function succeeded, or
 *          @c ZYDIS_STATUS_INSUFFICIENT_BUFFER_SIZE, if the size of the buffer was not
 *          sufficient to append the given @c text.
 */
 ZydisStatus ZydisStringAppendStatic(ZydisString* string,
    const ZydisStaticString* text, ZydisLetterCase letterCase);

/**
 * @brief   Appends the given 'ZydisStaticString' to a `ZydisString`, converting it to the
 *          specified letter-case.
 *
 * @param   string      The string to append to.
 * @param   text        The static-string to append.
 * @param   letterCase  The letter case to use.
 *
 * @return  @c ZYDIS_STATUS_SUCCESS, if the function succeeded, or
 *          @c ZYDIS_STATUS_INSUFFICIENT_BUFFER_SIZE, if the size of the buffer was not
 *          sufficient to append the given @c text.
 */
 ZydisStatus ZydisStringAppendExStatic(ZydisString* string,
    const ZydisStaticString* text, ZydisLetterCase letterCase);

/* ---------------------------------------------------------------------------------------------- */
/* Formatting                                                                                     */
/* ---------------------------------------------------------------------------------------------- */

/**
 * @brief   Formats the given unsigned ordinal @c value to its decimal text-representation and
 *          appends it to the @c string.
 *
 * @param   string          A pointer to the string.
 * @param   value           The value.
 * @param   paddingLength   Padds the converted value with leading zeros, if the number of chars is
 *                          less than the @c paddingLength.
 *
 * @return  @c ZYDIS_STATUS_SUCCESS, if the function succeeded, or
 *          @c ZYDIS_STATUS_INSUFFICIENT_BUFFER_SIZE, if the size of the buffer was not
 *          sufficient to append the given @c value.
 *
 * The string-buffer pointer is increased by the number of chars written, if the call was
 * successfull.
 */
 ZydisStatus ZydisStringAppendDecU(ZydisString* string, ZydisU64 value,
    ZydisU8 paddingLength);

/**
 * @brief   Formats the given signed ordinal @c value to its decimal text-representation and
 *          appends it to the @c string.
 *
 * @param   string          A pointer to the string.
 * @param   value           The value.
 * @param   paddingLength   Padds the converted value with leading zeros, if the number of chars is
 *                          less than the @c paddingLength (the sign char is ignored).
 *
 * @return  @c ZYDIS_STATUS_SUCCESS, if the function succeeded, or
 *          @c ZYDIS_STATUS_INSUFFICIENT_BUFFER_SIZE, if the size of the buffer was not
 *          sufficient to append the given @c value.
 *
 * The string-buffer pointer is increased by the number of chars written, if the call was
 * successfull.
 */
 ZydisStatus ZydisStringAppendDecS(ZydisString* string, ZydisI64 value,
    ZydisU8 paddingLength);

/**
 * @brief   Formats the given unsigned ordinal @c value to its hexadecimal text-representation and
 *          appends it to the @c string.
 *
 * @param   string          A pointer to the string.
 * @param   value           The value.
 * @param   paddingLength   Padds the converted value with leading zeros, if the number of chars is
 *                          less than the @c paddingLength.
 * @param   uppercase       Set @c TRUE to print the hexadecimal value in uppercase letters instead
 *                          of lowercase ones.
 * @param   prefix          The string to use as prefix or `NULL`, if not needed.
 * @param   suffix          The string to use as suffix or `NULL`, if not needed.
 *
 * @return  @c ZYDIS_STATUS_SUCCESS, if the function succeeded, or
 *          @c ZYDIS_STATUS_INSUFFICIENT_BUFFER_SIZE, if the size of the buffer was not
 *          sufficient to append the given @c value.
 *
 * The string-buffer pointer is increased by the number of chars written, if the call was
 * successfull.
 */
 ZydisStatus ZydisStringAppendHexU(ZydisString* string, ZydisU64 value,
    ZydisU8 paddingLength, ZydisBool uppercase, const ZydisString* prefix,
    const ZydisString* suffix);

/**
 * @brief   Formats the given signed ordinal @c value to its hexadecimal text-representation and
 *          appends it to the @c string.
 *
 * @param   string          A pointer to the string.
 * @param   value           The value.
 * @param   paddingLength   Padds the converted value with leading zeros, if the number of chars is
 *                          less than the @c paddingLength (the sign char is ignored).
 * @param   uppercase       Set @c TRUE to print the hexadecimal value in uppercase letters instead
 *                          of lowercase ones.
 * @param   prefix          The string to use as prefix or `NULL`, if not needed.
 * @param   suffix          The string to use as suffix or `NULL`, if not needed.
 *
 * @return  @c ZYDIS_STATUS_SUCCESS, if the function succeeded, or
 *          @c ZYDIS_STATUS_INSUFFICIENT_BUFFER_SIZE, if the size of the buffer was not
 *          sufficient to append the given @c value.
 *
 * The string-buffer pointer is increased by the number of chars written, if the call was
 * successfull.
 */
 ZydisStatus ZydisStringAppendHexS(ZydisString* string, ZydisI64 value,
    ZydisU8 paddingLength, ZydisBool uppercase, const ZydisString* prefix,
    const ZydisString* suffix);
]]

