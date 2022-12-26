-- Module --

local fspp = {}

-- Main Code --
local ffi = require(jit and "ffi" or "cffi")

ffi.cdef[[
typedef struct Vector Vector;

void freeCCVector(Vector*);
int getCCVectorSize(Vector*);
const char* getCCVectorValue(Vector*, int);

const char* FSPP_absolute(const char* path);
void FSPP_copy(const char*, const char*);
int FSPP_createdirectory(const char*);
Vector* FSPP_directoryiterator(const char*);
]]

fspp.extfile =
	ffi.os == "Windows" and
	".dll" or ffi.os == "Linux" and
	".so" or ffi.os == "OSX" and
	".dylib"

local fspp_core
for s in package.cpath:gmatch  "([^;]+)" do
	local ext = fspp.extfile

	s = s:gsub("%?.-$","")
	if pcall(ffi.load,s.."fspp-core"..ext) then
		fspp_core = ffi.load(s.."fspp-core"..ext)
		break
	end
end

if not fspp_core then
	error("cannot find shared library 'fspp-core"..fspp.extfile.."'!")
end

print(ffi.string(fspp_core.FSPP_absolute "a"))
