#include <cstring>

#include <iostream>
#include <filesystem>
#include <map>
#include <memory>
#include <string>
#include <vector>

#define C extern "C"

namespace fs = std::filesystem;

/* Misc */

C int getCCVectorSize(std::vector<const char*>* vec) {
	return vec->size();
}

C const char* getCCVectorValue(std::vector<const char*>* vec, int i) {
	return vec->at(i);
}

C void freeCCVector(std::vector<const char*>* vec) {
	delete vec;
}

/* Non-member functions */

C const char* FSPP_absolute(const char* path) {
	std::string* NewPath = new std::string{fs::absolute(path)};
	return NewPath->c_str();
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

C void FSPP_copy(const char* from, const char* to) {
	fs::copy(from,to);
}

C int FSPP_copyfile(const char* from, const char* to) {
	return fs::copy_file(from,to);
}

C void FSPP_copysymlink(const char* from, const char* to) {
	fs::copy_symlink(from,to);
}

C int FSPP_createdirectory(const char* path) {
	return fs::create_directory(path);
}

C int FSPP_arg2_createdirectory(const char* path, const char* existing_path) {
	return fs::create_directory(path,existing_path);
}

C int FSPP_createdirectories(const char* path) {
	return fs::create_directories(path);
}

C void FSPP_createhardlink(const char* target, const char* link) {
	fs::create_hard_link(target,link);
}

C std::vector<const char*>* FSPP_directoryiterator(const char* Cpath) {
	fs::path path(Cpath);

	std::vector<const char*>* vec = new std::vector<const char*>;
	for (auto const& entry : fs::directory_iterator{path}) {
		std::string* content = new std::string{entry.path()};
		vec->push_back(content->c_str());
	}

	return vec;
}
