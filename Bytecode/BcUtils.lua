local parser = {}
parser.__index = parser

function parser.new(file)
	local self = setmetatable({}, parser)

	self.bytecode = tostring(file)
	self.pos = 1
	self.size = #tostring(file)
	self.sizeT = 8 -- def 8

	return self
end

function parser:ReadByte()
	if self.pos > self.size then
		error(string.format("ReadByte: attempt to read beyond end (pos=%d, size=%d)", self.pos, self.size))
	end
	local byte = self.bytecode:byte(self.pos)
	if not byte then
		error(string.format("ReadByte: failed at pos=%d, size=%d", self.pos, self.size))
	end
	self.pos = self.pos + 1
	return byte
end

function parser:ReadBytes(count)
	if self.pos + count - 1 > self.size then
		error(string.format("ReadBytes: attempt to read beyond end (pos=%d, count=%d, size=%d)", 
			self.pos, count, self.size))
	end
	local bytes = self.bytecode:sub(self.pos, self.pos + count - 1)
	if #bytes ~= count then
		error(string.format("ReadBytes: expected %d bytes, got %d (pos=%d, size=%d)", 
			count, #bytes, self.pos, self.size))
	end
	self.pos = self.pos + count
	return bytes 
end

function parser:ReadInt32()
	local b1, b2, b3, b4 = self.bytecode:byte(self.pos, self.pos + 3)
	self.pos = self.pos + 4
	return b1 + b2 * 256 + b3 * 65536 + b4 * 16777216
end

function parser:ReadSizeT()
	if self.sizeT == 8 then
		local low = self:ReadInt32()
		local high = self:ReadInt32()
		return low
	else
		return self:ReadInt32()
	end
end

function parser:ReadDouble()
	local bytes = self:ReadBytes(8)

	if #bytes ~= 8 then
		error("ReadDouble: expected 8 bytes, got " .. #bytes)
	end

	local b = {bytes:byte(1, 8)}

	if not (b[1] and b[2] and b[3] and b[4] and b[5] and b[6] and b[7] and b[8]) then
		error("ReadDouble: failed to read all 8 bytes")
	end

	local sign = (b[8] >= 128) and -1 or 1
	local exp_byte8 = b[8] % 128
	local exp_byte7 = math.floor(b[7] / 16)
	local exponent = exp_byte8 * 16 + exp_byte7

	local mant_high = b[7] % 16
	local mantissa = 0

	for i = 1, 6 do
		mantissa = mantissa + b[i] * (256 ^ (i - 1))
	end
	mantissa = mantissa + mant_high * (256 ^ 6)

	if exponent == 0 then
		if mantissa == 0 then
			return sign * 0
		else
			return sign * math.ldexp(mantissa, -1022 - 52)
		end
	elseif exponent == 2047 then
		if mantissa == 0 then
			return sign * (1/0)
		else
			return 0/0 
		end
	else
		return sign * math.ldexp(1 + mantissa / (2^52), exponent - 1023)
	end
end

function parser:ReadString()
	local length = self:ReadSizeT()
	if length == 0 then
		return nil
	end
	
	local str = self:ReadBytes(length - 1)
	self:ReadByte()
	return str
end

return parser