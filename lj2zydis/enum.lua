local pow = math.pow
local bit = require("bit")
local lshift, rshift, band, bor = bit.lshift, bit.rshift, bit.band, bit.bor

--[[
-- metatable for enums
-- simply provides the 'reverse lookup' in a 
-- dictionary.  Make this the metatable whenever
-- you need such functionality.
-- 
Usage:
    local myenum = enum {
        name1 = value1;
        name2 = value2;
        name3 = value3;
    }
--]]

local enum = {}
setmetatable(enum, {
    __call = function(self, ...)
        return self:create(...)
    end,
})

local enum_mt = {
    __index = function(tbl, value)
        for key, code in pairs(tbl) do
            if code == value then 
                return key;
            end
        end

        return false;
    end;
}
function enum.init(self, alist)
    setmetatable(alist, enum_mt)

    return alist;
end

function enum.create(self, alist)
    local alist = alist or {}
    return self:init(alist);
end

--[[
	Function: enumbits
	Parameters: 
		bistValue - this is an integer value representing the bit flags
		tbl - the table the contains the name/value pairs that define the meaning of the bit flags
		bitsSize - how many bits are in the numeric values, default is 32
		
	Description: Given an integer value that represents a bunch of individual
	flags of some state, we want to get the string value which 
	is used as a key to represent the integer flag value in a table.

	The enumbits() function returns an iterator, which will push
	out the names of the individual bits, as they are found in a 
	table.

	for _, name in enumbits(0x04000001, tbleOfValues, b2) do
		print(name)
	end
--]]

function enum.enumbits(tbl, bitsValue, bitsSize)
	local function name_gen(params, state)
		if state >= params.bitsSize then return nil; end

		while(true) do
			local mask = pow(2,state)
			local maskedValue = band(mask, params.bitsValue)
--print(string.format("(%2d) MASK [%x] - %#x", state, mask, maskedValue))			
			if maskedValue ~= 0 then
				return state + 1, params.tbl[maskedValue] or "UNKNOWN"
			end

			state = state + 1;
			if state >= params.bitsSize then return nil; end
		end

		return nil;
	end

	return name_gen, {bitsValue = bitsValue, tbl = tbl, bitsSize = bitsSize or 32}, 0
end

--[[
    When a value represents a composite set of bits
    return the value as a string expansion of the bit values
]]
function enum.bitValues(tbl, value, bitsSize)
    local res = {}
    for _, name in enum.enumbits(tbl, value, bitsSize) do
        table.insert(res, name)
    end
    return table.concat(res,', ')
end

function enum.inject(self, tbl)
	tbl = tbl or _G;
	for k,v in pairs(self) do
		rawset(tbl, k, v);
	end
end

return enum
