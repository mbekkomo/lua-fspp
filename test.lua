local fspp = require 'fspp'

local path1 = fspp.Path 'README.md'
local path2 = fspp.Path(fspp.current_path()..'README.md')

print('path1:',path1:is_absolute(),path1:is_relative())
print('path2:',path2:is_absolute(),path2:is_relative())
