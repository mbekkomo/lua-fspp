#include <iostream>
#include <filesystem>

extern "C" {
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
}

namespace fs = std::filesystem;





/* Utils */

static void fspp_regstr(lua_State *L, const char* index, const char* value) {
	lua_pushstring(L,value);
	lua_setfield(L,-2,index);
}

static void fspp_regcfun(lua_State *L, const char* index, lua_CFunction fun) {
	lua_pushcfunction(L, fun);
	lua_setfield(L,-2,index);
}

/* Path class */

static int fspp_path_isrelative(lua_State *L) {
	lua_getfield(L,1,"path");

	fs::path fspp_path = luaL_checkstring(L,2);

	lua_pushboolean(L, int(fspp_path.is_relative()));
	return 1;
}


static int fspp_path_isabsolute(lua_State *L) {
	lua_getfield(L,1,"path");

	fs::path fspp_path = luaL_checkstring(L,2);

	lua_pushboolean(L, int(fspp_path.is_absolute()));
	return 1;
}


static int fspp_path_parentpath(lua_State *L) {
	lua_getfield(L,1,"path");

	fs::path fspp_path = luaL_checkstring(L,2);

	lua_pushstring(L,fspp_path.parent_path().c_str());
	return 1;
}


static int fspp_path_extension(lua_State *L) {
	lua_getfield(L,1,"path");

	fs::path fspp_path = luaL_checkstring(L,2);

	lua_pushstring(L,fspp_path.extension().c_str());
	return 1;
}

static int fspp_path_filename(lua_State *L) {
	lua_getfield(L,1,"path");

	fs::path fspp_path = luaL_checkstring(L, 2);

	lua_pushstring(L,fspp_path.filename().c_str());
	return 1;
}


static int fspp_path_append(lua_State *L) {
	lua_getfield(L,1,"path"); // 2
	const char* append_str = luaL_checkstring(L,2);

	fs::path fspp_path = luaL_checkstring(L,3);

	fspp_path.append(append_str);

	lua_pushstring(L, fspp_path.c_str());
	return 1;
}


static int fspp_path_absolute(lua_State *L) {
	lua_getfield(L,1,"path");

	fs::path fspp_path = luaL_checkstring(L, -1);

	lua_pushstring(L, fs::absolute(fspp_path).c_str());
	return 1;
}


static int fspp_path_constructor(lua_State *L) { // Constructor
	const char *path_str = luaL_checkstring(L, 1); // 1 (string)

	lua_createtable(L,0,3); // 2 (string, {})

	fspp_regstr(L,"path",path_str);
	fspp_regcfun(L,"append",fspp_path_append);
	fspp_regcfun(L,"absolute",fspp_path_absolute);
	fspp_regcfun(L,"filename",fspp_path_filename);
	fspp_regcfun(L,"extension",fspp_path_extension);
	fspp_regcfun(L,"parent_path",fspp_path_parentpath);
	fspp_regcfun(L,"is_absolute",fspp_path_isabsolute);
	fspp_regcfun(L,"is_relative",fspp_path_isrelative);

	return 1;
}





/* Utils function */

static int fspp_current_path(lua_State* L) {
	fs::path path_curr = fs::current_path();

	lua_pushstring(L,path_curr.string().c_str());
	return 1;
}







static const struct luaL_Reg fspp[] = {
	{"current_path",fspp_current_path},
	{"Path",fspp_path_constructor},
	{NULL,NULL}
};

extern "C" {

int luaopen_fspp(lua_State *L) {
	luaL_newlib(L,fspp);
	return 1;
}

}
