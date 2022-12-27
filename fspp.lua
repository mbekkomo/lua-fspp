local ffi = require(jit and "ffi" or "cffi")

-- Module --
local fspp = {}

fspp.extfile = package.cpath:match ";(./%?%.%a+);?":match "%.%a+$"
print(fspp.extfile)

local fspp_core
for s in package.cpath:gmatch  "([^;]+)" do
	s = s:gsub("%?.-$","")
	fspp_core = assert(ffi.load(s.."fspp-core"..fspp.extfile),
	"cannot load 'fspp-core"..fspp.extfile"' in package.cpath, shared library not found!")
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
	if not opts or opts and #opts < 1 then
		fspp_core.FSPP_copy(from, to, 0)
	else fspp_core.FSPP_copy(from, to, #opts, table.unpack(opts)) end
end

fspp.copy("Makefile","../Makefile")
