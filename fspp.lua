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

local ext = --V--
	ffi.os == "Windows" and
	".dll" or ffi.os == "Linux" and
	".so" or ffi.os == "Darwin" and
	".dylib"

local fspp
for s in package.cpath:gmatch  "([^;]+)" do
	s = s:gsub("%?.-$","")
	if pcall(ffi.load,s.."fspp-core"..ext) then
		fspp = ffi.load(s.."fspp-core"..ext)
		break
	end
end

if not fspp then
	error("cannot find shared library 'fspp-core"..ext.."'!")
end

local vec = fspp.FSPP_directoryiterator "."

for i = 0, fspp.getCCVectorSize(vec) - 1 do
	print(i, ffi.string(fspp.getCCVectorValue(vec,i)))
end

fspp.freeCCVector(vec)
