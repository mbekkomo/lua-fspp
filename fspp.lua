local ffi = require "ffi"

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

local fspp
for s in package.path:gmatch  "([^;]+)" do
	s = s:gsub("%?.-$","")
	if pcall(ffi.load,s.."libfspp.so") then
		fspp = ffi.load(s.."libfspp.so")
		break
	end
end

if not fspp then
	error "cannot find 'libfspp.so'!"
end


local dirVec = fspp.FSPP_directoryiterator "."

for i = 0, fspp.getCCVectorSize(dirVec) - 1 do
	print(i,ffi.string(fspp.getCCVectorValue(dirVec,i)))
end

fspp.freeCCVector(dirVec)
