local fspp = require 'fspp'

describe('fspp',function()
	describe('should',function()
		it('returns current path',function()
			local curr_path = fspp.current_path()

			assert.truthy(curr_path)
		end)
	end)

	describe('return boolean false',function()
		it('if Path is not relative path',function()
			local fspp_path = fspp.Path '/home'

			assert.is_false(fspp_path:is_relative())
		end)

		it('if Path is not absolute path',function()
			local fspp_path = fspp.Path './README.md'

			assert.is_false(fspp_path:is_absolute())
		end)
	end)

	describe('return boolean true',function()
		it('if Path is relative path',function()
			local fspp_path = fspp.Path './LICENSE'

			assert.is_true(fspp_path:is_relative())
		end)

		it('if Path is absolute path',function()
			local fspp_path = fspp.Path '/usr'

			assert.is_true(fspp_path:is_absolute())
		end)
	end)
end)
