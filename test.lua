local ffi = require "ffi"

ffi.cdef[[
const char* FSPP_absolute(const char* path);
void FSPP_copy(const char*, const char*);
]]
local fspp = ffi.load "./libfspp.so"

print(fspp.FSPP_copy("a","src/a"))
