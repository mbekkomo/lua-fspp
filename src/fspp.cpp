#include <iostream>
#include <filesystem>
#include <map>
#include <string>

namespace fs = std::filesystem;

/* Non-member functions */

extern "C"
const char* FSPP_absolute(const char* path) {
	return fs::absolute(std::string{path}).string().c_str();
}

/*

std::map<std::string, fs::copy_options> CopyOptions = {
	{"none", fs::copy_options::none},
	{"skip_existing", fs::copy_options::skip_existing},
	{"overwrite_existing", fs::copy_options::overwrite_existing},
	{"update_existing", fs::copy_options::update_existing},
	{"recursive", fs::copy_options::recursive},
	{"copy_symlinks", fs::copy_options::copy_symlinks},
	{"skip_symlinks", fs::copy_options::skip_symlinks},
	{"directories_only", fs::copy_options::directories_only},
	{"create_symlinks", fs::copy_options::create_symlinks},
	{"create_hard_links", fs::copy_options::create_hard_links}
};

*/

extern "C" 
void FSPP_copy(const char* from, const char* to) {
	fs::copy(from,to);
}
