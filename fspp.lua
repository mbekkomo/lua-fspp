--[[
 _____ ____  ____  ____
|  ___/ ___||  _ \|  _ \  || C++17 filesystem binding for Lua
| |_  \___ \| |_) | |_) | || https://github.com/UrNightmaree/filesystempp
|  _|  ___) |  __/|  __/  ||
|_|   |____/|_|   |_|     ||


MIT License

Copyright (c) 2022 Koosh

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]


local ffi = require(jit and "ffi" or "cffi")

-- Module --
local fspp = {}

fspp.extfile = package.cpath:match "%?%.[^;]+":match "[^?]+"

local fspp_core
for s in package.cpath:gmatch  "([^;]+)" do
	s = s:gsub("%?.-$","")

	if pcall(ffi.load, s.."fspp-core"..fspp.extfile) then
		fspp_core = ffi.load(s.."fspp-core"..fspp.extfile)
		break
	end
end

if not fspp_core then
	error("cannot find shared library 'fspp-core"..fspp.extfile.."' in package.cpath!")
end


-- Main Code --
ffi.cdef[[
typedef struct Vector Vector;

void freeCCVector(Vector*);
int getCCVectorSize(Vector*);
const char* getCCVectorValue(Vector*, int);

const char* FSPP_absolute(const char* path);
void FSPP_copy(const char* from, const char* to, int n, ...);
int FSPP_createdirectory(const char*);
Vector* FSPP_directoryiterator(const char*);
]]

function fspp.directory_iterator(path)
	local content = fspp_core.FSPP_directoryiterator(path)

	local table_content = {}
	for i = 0, fspp_core.getCCVectorSize(content) - 1 do
		table.insert(table_content, ffi.string(fspp_core.getCCVectorValue(content, i)))
	end

	fspp_core.freeCCVector(content)

	local i, n = 0, #table_content
	return function()
		i = i + 1
		if i < n then return table_content[i + 1] end
	end
end

function fspp.copy(from,to,opts)
	local unpack = unpack or table.unpack

	if not opts or opts and #opts < 1 then
		fspp_core.FSPP_copy(from, to, 0)
	else fspp_core.FSPP_copy(from, to, #opts, unpack(opts)) end
end
