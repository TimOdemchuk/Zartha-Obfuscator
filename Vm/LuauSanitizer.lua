-- Convert all Luau-specific syntax to standard Lua

local Sanitizer = {}

local TOKEN_TYPES = {
	WHITESPACE = "whitespace",
	COMMENT = "comment",
	STRING = "string",
	INTERPOLATED_STRING = "interpolated_string",
	NUMBER = "number",
	IDENTIFIER = "identifier",
	KEYWORD = "keyword",
	OPERATOR = "operator",
	COMPOUND_ASSIGN = "compound_assign",
	SYMBOL = "symbol",
	VARARG = "vararg",
	EOF = "eof"
}

local KEYWORDS = {
	["and"] = true,
	["break"] = true,
	["do"] = true,
	["else"] = true,
	["elseif"] = true,
	["end"] = true,
	["false"] = true,
	["for"] = true,
	["function"] = true,
	["if"] = true,
	["in"] = true,
	["local"] = true,
	["nil"] = true,
	["not"] = true,
	["or"] = true,
	["repeat"] = true,
	["return"] = true,
	["then"] = true,
	["true"] = true,
	["until"] = true,
	["while"] = true,
	["type"] = true,
	["export"] = true
}

local function isAlpha(c)
	return (c >= "a" and c <= "z") or (c >= "A" and c <= "Z") or c == "_"
end

local function isDigit(c)
	return c >= "0" and c <= "9"
end

local function isAlphaNum(c)
	return isAlpha(c) or isDigit(c)
end

local function isWhitespace(c)
	return c == " " or c == "\t" or c == "\n" or c == "\r"
end

local Lexer = {}
Lexer.__index = Lexer

function Lexer.new(source)
	local self = setmetatable({}, Lexer)
	self.source = source
	self.pos = 1
	self.tokens = {}
	return self
end

function Lexer:peek(offset)
	offset = offset or 0
	local pos = self.pos + offset
	if pos > #self.source then
		return "\0"
	end
	return self.source:sub(pos, pos)
end

function Lexer:advance(count)
	count = count or 1
	self.pos = self.pos + count
end

function Lexer:readWhile(predicate)
	local start = self.pos
	while self.pos <= #self.source and predicate(self:peek()) do
		self:advance()
	end
	return self.source:sub(start, self.pos - 1)
end

function Lexer:skipWhitespace()
	local start = self.pos
	while self.pos <= #self.source and isWhitespace(self:peek()) do
		self:advance()
	end
	if self.pos > start then
		return {
			type = TOKEN_TYPES.WHITESPACE,
			value = self.source:sub(start, self.pos - 1)
		}
	end
	return nil
end

function Lexer:readString(quote)
	local start = self.pos
	self:advance()
	while self.pos <= #self.source do
		local c = self:peek()
		if c == "\\" then
			self:advance(2)
		elseif c == quote then
			self:advance()
			break
		else
			self:advance()
		end
	end
	return {
		type = TOKEN_TYPES.STRING,
		value = self.source:sub(start, self.pos - 1)
	}
end

function Lexer:readLongString()
	local start = self.pos
	self:advance()
	local eqCount = 0
	while self:peek() == "=" do
		eqCount = eqCount + 1
		self:advance()
	end
	if self:peek() ~= "[" then
		return {
			type = TOKEN_TYPES.SYMBOL,
			value = "["
		}
	end
	self:advance()
	local closePattern = "]" .. string.rep("=", eqCount) .. "]"
	while self.pos <= #self.source do
		if self.source:sub(self.pos, self.pos + #closePattern - 1) == closePattern then
			self:advance(#closePattern)
			break
		end
		self:advance()
	end
	return {
		type = TOKEN_TYPES.STRING,
		value = self.source:sub(start, self.pos - 1)
	}
end

function Lexer:readComment()
	local start = self.pos
	self:advance(2)
	if self:peek() == "[" then
		local eqStart = self.pos
		self:advance()
		local eqCount = 0
		while self:peek() == "=" do
			eqCount = eqCount + 1
			self:advance()
		end
		if self:peek() == "[" then
			self:advance()
			local closePattern = "]" .. string.rep("=", eqCount) .. "]"
			while self.pos <= #self.source do
				if self.source:sub(self.pos, self.pos + #closePattern - 1) == closePattern then
					self:advance(#closePattern)
					break
				end
				self:advance()
			end
			return {
				type = TOKEN_TYPES.COMMENT,
				value = self.source:sub(start, self.pos - 1)
			}
		else
			self.pos = eqStart
		end
	end
	while self.pos <= #self.source and self:peek() ~= "\n" do
		self:advance()
	end
	return {
		type = TOKEN_TYPES.COMMENT,
		value = self.source:sub(start, self.pos - 1)
	}
end

function Lexer:readInterpolatedString()
	local start = self.pos
	self:advance()
	while self.pos <= #self.source and self:peek() ~= "`" do
		if self:peek() == "\\" then
			self:advance(2)
		else
			self:advance()
		end
	end
	self:advance()
	return {
		type = TOKEN_TYPES.INTERPOLATED_STRING,
		value = self.source:sub(start, self.pos - 1)
	}
end

function Lexer:readNumber()
	local start = self.pos
	if self:peek() == "0" and (self:peek(1) == "x" or self:peek(1) == "X") then
		self:advance(2)
		self:readWhile(function(c)
			return isDigit(c) or (c >= "a" and c <= "f") or (c >= "A" and c <= "F")
		end)
	else
		self:readWhile(isDigit)
		if self:peek() == "." and isDigit(self:peek(1)) then
			self:advance()
			self:readWhile(isDigit)
		end
		if self:peek() == "e" or self:peek() == "E" then
			self:advance()
			if self:peek() == "+" or self:peek() == "-" then
				self:advance()
			end
			self:readWhile(isDigit)
		end
	end
	return {
		type = TOKEN_TYPES.NUMBER,
		value = self.source:sub(start, self.pos - 1)
	}
end

function Lexer:readIdentifier()
	local start = self.pos
	self:readWhile(isAlphaNum)
	local value = self.source:sub(start, self.pos - 1)
	local tokenType = KEYWORDS[value] and TOKEN_TYPES.KEYWORD or TOKEN_TYPES.IDENTIFIER
	return {
		type = tokenType,
		value = value
	}
end

function Lexer:tokenize()
	while self.pos <= #self.source do
		local c = self:peek()
		local c2 = self.source:sub(self.pos, self.pos + 1)
		local c3 = self.source:sub(self.pos, self.pos + 2)
		if isWhitespace(c) then
			table.insert(self.tokens, self:skipWhitespace())
		elseif c2 == "--" then
			table.insert(self.tokens, self:readComment())
		elseif c == '"' or c == "'" then
			table.insert(self.tokens, self:readString(c))
		elseif c == "[" and (self:peek(1) == "[" or self:peek(1) == "=") then
			table.insert(self.tokens, self:readLongString())
		elseif c == "`" then
			table.insert(self.tokens, self:readInterpolatedString())
		elseif isDigit(c) or (c == "." and isDigit(self:peek(1))) then
			table.insert(self.tokens, self:readNumber())
		elseif isAlpha(c) then
			table.insert(self.tokens, self:readIdentifier())
		elseif c3 == "..." then
			table.insert(self.tokens, {
				type = TOKEN_TYPES.VARARG,
				value = "..."
			})
			self:advance(3)
		elseif c3 == "..=" then
			table.insert(self.tokens, {
				type = TOKEN_TYPES.COMPOUND_ASSIGN,
				value = "..="
			})
			self:advance(3)
		elseif c2 == "+=" or c2 == "-=" or c2 == "*=" or c2 == "/=" or c2 == "%=" or c2 == "^=" then
			table.insert(self.tokens, {
				type = TOKEN_TYPES.COMPOUND_ASSIGN,
				value = c2
			})
			self:advance(2)
		elseif c2 == "->" or c2 == "::" or c2 == "==" or c2 == "~=" or c2 == "<=" or c2 == ">=" or c2 == ".." then
			table.insert(self.tokens, {
				type = TOKEN_TYPES.OPERATOR,
				value = c2
			})
			self:advance(2)
		else
			table.insert(self.tokens, {
				type = TOKEN_TYPES.SYMBOL,
				value = c
			})
			self:advance()
		end
	end
	table.insert(self.tokens, {
		type = TOKEN_TYPES.EOF,
		value = ""
	})
	return self.tokens
end

local Parser = {}
Parser.__index = Parser

function Parser.new(tokens)
	local self = setmetatable({}, Parser)
	self.tokens = tokens
	self.pos = 1
	self.output = {}
	return self
end

function Parser:peek(offset)
	offset = offset or 0
	local pos = self.pos + offset
	if pos > #self.tokens then
		return self.tokens[#self.tokens]
	end
	return self.tokens[pos]
end

function Parser:current()
	return self:peek(0)
end

function Parser:advance()
	local token = self.tokens[self.pos]
	self.pos = self.pos + 1
	return token
end

function Parser:emit(value)
	table.insert(self.output, value)
end

function Parser:emitToken(token)
	if token then
		table.insert(self.output, token.value)
	end
end

function Parser:skipNonCode()
	while self:current().type == TOKEN_TYPES.WHITESPACE or self:current().type == TOKEN_TYPES.COMMENT do
		self:emitToken(self:advance())
	end
end

function Parser:peekNonWhitespace(offset)
	offset = offset or 0
	local pos = self.pos
	local count = 0
	while pos <= #self.tokens do
		local t = self.tokens[pos]
		if t.type ~= TOKEN_TYPES.WHITESPACE and t.type ~= TOKEN_TYPES.COMMENT then
			if count == offset then
				return t
			end
			count = count + 1
		end
		pos = pos + 1
	end
	return self.tokens[#self.tokens]
end

function Parser:skipTypeAnnotation()
	local depth = 0
	while self:current().type ~= TOKEN_TYPES.EOF do
		local t = self:current()
		if t.type == TOKEN_TYPES.WHITESPACE then
			self:advance()
		elseif t.value == "<" or t.value == "(" or t.value == "{" then
			depth = depth + 1
			self:advance()
		elseif t.value == ">" or t.value == ")" or t.value == "}" then
			if depth > 0 then
				depth = depth - 1
				self:advance()
			else
				break
			end
		elseif (t.value == "," or t.value == "=" or t.value == ";") and depth == 0 then
			break
		elseif t.type == TOKEN_TYPES.IDENTIFIER or t.type == TOKEN_TYPES.KEYWORD or 
               t.value == "|" or t.value == "&" or t.value == "?" or t.value == "." or 
               t.value == ":" or t.value == "[" or t.value == "]" or t.type == TOKEN_TYPES.VARARG or
               t.type == TOKEN_TYPES.NUMBER or t.type == TOKEN_TYPES.STRING then
			self:advance()
		elseif t.value == "-" and self:peekNonWhitespace(1).value == ">" then
			self:advance()
			while self:current().type == TOKEN_TYPES.WHITESPACE do
				self:advance()
			end
			self:advance()
		else
			break
		end
	end
end

function Parser:parseTypeDeclaration()
	while self:current().type ~= TOKEN_TYPES.EOF do
		local t = self:current()
		if t.type == TOKEN_TYPES.WHITESPACE and t.value:find("\n") then
			self:advance()
			break
		elseif t.type == TOKEN_TYPES.EOF then
			break
		else
			self:advance()
		end
	end
end

function Parser:parseFunctionParams()
	self:emit("(")
	self:advance()
	local first = true
	while self:current().type ~= TOKEN_TYPES.EOF and self:current().value ~= ")" do
		local t = self:current()
		if t.type == TOKEN_TYPES.WHITESPACE then
			self:emitToken(self:advance())
		elseif t.value == "," then
			self:emitToken(self:advance())
			first = false
		elseif t.type == TOKEN_TYPES.IDENTIFIER or t.type == TOKEN_TYPES.VARARG then
			self:emitToken(self:advance())
			while self:current().type == TOKEN_TYPES.WHITESPACE do
				self:emitToken(self:advance())
			end
			if self:current().value == ":" then
				self:advance()
				self:skipTypeAnnotation()
			end
		else
			self:emitToken(self:advance())
		end
	end

	if self:current().value == ")" then
		self:emit(")")
		self:advance()
	end

	while self:current().type == TOKEN_TYPES.WHITESPACE do
		self:emitToken(self:advance())
	end

	if self:current().value == ":" then
		self:advance()
		self:skipTypeAnnotation()
	elseif self:current().value == "-" and self:peekNonWhitespace(1).value == ">" then
		self:advance()
		while self:current().type == TOKEN_TYPES.WHITESPACE do
			self:advance()
		end
		self:advance()
		self:skipTypeAnnotation()
	end
end

function Parser:parseInterpolatedString(token)
	local content = token.value:sub(2, #token.value - 1)
	local parts = {}
	local pos = 1
	local currentStr = ""

	while pos <= #content do
		local c = content:sub(pos, pos)
		if c == "\\" and pos + 1 <= #content then
			currentStr = currentStr .. content:sub(pos + 1, pos + 1)
			pos = pos + 2
		elseif c == "{" then
			if currentStr ~= "" then
				table.insert(parts, {
					type = "str",
					value = currentStr
				})
				currentStr = ""
			end
			local braceDepth = 1
			local exprStart = pos + 1

			pos = pos + 1

			while pos <= #content and braceDepth > 0 do
				if content:sub(pos, pos) == "{" then
					braceDepth = braceDepth + 1
				elseif content:sub(pos, pos) == "}" then
					braceDepth = braceDepth - 1
				end
				pos = pos + 1
			end
			local expr = content:sub(exprStart, pos - 2)
			table.insert(parts, {
				type = "expr",
				value = expr
			})
		else
			currentStr = currentStr .. c
			pos = pos + 1
		end
	end

	if currentStr ~= "" then
		table.insert(parts, {
			type = "str",
			value = currentStr
		})
	end

	if #parts == 0 then
		self:emit('""')
	elseif #parts == 1 and parts[1].type == "str" then
		self:emit('"' .. parts[1].value .. '"')
	else
		self:emit("(")
		for j, part in ipairs(parts) do
			if j > 1 then
				self:emit(" .. ")
			end
			if part.type == "str" then
				self:emit('"' .. part.value .. '"')
			else
				self:emit("tostring(" .. part.value .. ")")
			end
		end
		self:emit(")")
	end
end

function Parser:collectVariable()
	local varTokens = {}
	local i = #self.output
	local parenDepth = 0
	local bracketDepth = 0

	while i >= 1 do
		local val = self.output[i]
		if val:match("^%s+$") then
			i = i - 1
		elseif val == ")" then
			parenDepth = parenDepth + 1
			table.insert(varTokens, 1, val)
			self.output[i] = nil
			i = i - 1
		elseif val == "(" then
			if parenDepth > 0 then
				parenDepth = parenDepth - 1
				table.insert(varTokens, 1, val)
				self.output[i] = nil
				i = i - 1
			else
				break
			end
		elseif val == "]" then
			bracketDepth = bracketDepth + 1
			table.insert(varTokens, 1, val)
			self.output[i] = nil
			i = i - 1
		elseif val == "[" then
			if bracketDepth > 0 then
				bracketDepth = bracketDepth - 1
				table.insert(varTokens, 1, val)
				self.output[i] = nil
				i = i - 1
			else
				break
			end
		elseif val:match("^[%w_]+$") or val == "." or val == ":" then
			table.insert(varTokens, 1, val)
			self.output[i] = nil
			i = i - 1
		else
			break
		end
	end

	while #self.output > 0 and self.output[#self.output] == nil do
		table.remove(self.output)
	end

	return table.concat(varTokens)
end

function Parser:parse()
	while self:current().type ~= TOKEN_TYPES.EOF do
		local t = self:current()
		repeat
			if t.type == TOKEN_TYPES.KEYWORD and (t.value == "type" or t.value == "export") then
				local isExport = t.value == "export"
				self:advance()
				if isExport then
					while self:current().type == TOKEN_TYPES.WHITESPACE do
						self:advance()
					end
					if self:current().value ~= "type" then
						self:emit("export")
						break
					end
					self:advance()
				end

				while self:current().type == TOKEN_TYPES.WHITESPACE do
					self:advance()
				end

				if self:current().type == TOKEN_TYPES.IDENTIFIER then
					local nextNonWs = self:peekNonWhitespace(1)
					if nextNonWs.value == "=" or nextNonWs.value == "<" then
						self:parseTypeDeclaration()
						break
					end
				end

				self:emit("type")
			elseif t.type == TOKEN_TYPES.KEYWORD and t.value == "function" then
				self:emitToken(self:advance())

				while self:current().type == TOKEN_TYPES.WHITESPACE do
					self:emitToken(self:advance())
				end

				while self:current().type == TOKEN_TYPES.IDENTIFIER or 
                      self:current().value == "." or self:current().value == ":" do
					self:emitToken(self:advance())
				end

				while self:current().type == TOKEN_TYPES.WHITESPACE do
					self:emitToken(self:advance())
				end

				if self:current().value == "<" then
					local depth = 1
					self:advance()
					while depth > 0 and self:current().type ~= TOKEN_TYPES.EOF do
						if self:current().value == "<" then
							depth = depth + 1
						end
						if self:current().value == ">" then
							depth = depth - 1
						end
						self:advance()
					end
					while self:current().type == TOKEN_TYPES.WHITESPACE do
						self:emitToken(self:advance())
					end
				end

				if self:current().value == "(" then
					self:parseFunctionParams()
				end

			elseif t.type == TOKEN_TYPES.KEYWORD and t.value == "local" then
				self:emitToken(self:advance())
				while self:current().type == TOKEN_TYPES.WHITESPACE do
					self:emitToken(self:advance())
				end
                
				if self:current().value == "function" then
					break
				end

				while self:current().type == TOKEN_TYPES.IDENTIFIER do
					self:emitToken(self:advance())
					while self:current().type == TOKEN_TYPES.WHITESPACE do
						self:emitToken(self:advance())
					end
					if self:current().value == ":" then
						self:advance()
						self:skipTypeAnnotation()
					end
					while self:current().type == TOKEN_TYPES.WHITESPACE do
						self:emitToken(self:advance())
					end
					if self:current().value == "," then
						self:emitToken(self:advance())
						while self:current().type == TOKEN_TYPES.WHITESPACE do
							self:emitToken(self:advance())
						end
					else
						break
					end
				end
			elseif t.type == TOKEN_TYPES.COMPOUND_ASSIGN then
				local op = t.value:sub(1, #t.value - 1)
				local varStr = self:collectVariable()
				self:emit(varStr)
				self:emit(" = ")
				self:emit(varStr)
				self:emit(" " .. op .. " ")
				self:advance()
			elseif t.type == TOKEN_TYPES.INTERPOLATED_STRING then
				self:parseInterpolatedString(t)
				self:advance()
			elseif t.value == "(" then
				local prevIdx = #self.output
				while prevIdx >= 1 and self.output[prevIdx]:match("^%s+$") do
					prevIdx = prevIdx - 1
				end
				if prevIdx >= 1 and self.output[prevIdx] == "function" then
					self:parseFunctionParams()
				else
					self:emitToken(self:advance())
				end
			else
				self:emitToken(self:advance())
			end
		until true
	end
	return table.concat(self.output)
end

function Sanitizer.sanitize(code)
	local lexer = Lexer.new(code)
	local tokens = lexer:tokenize()
	local parser = Parser.new(tokens)
	return parser:parse()
end

return Sanitizer