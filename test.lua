local ffi = require "ffi"

ffi.cdef[[
const char* FSPP_absolute(const char* path);
void FSPP_copy(const char*, const char*);
]]
local fspp = ffi.load "./libfspp.so"

print(ffi.string(fspp.FSPP_absolute("a")))
