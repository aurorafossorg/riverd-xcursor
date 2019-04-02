/*
                                    __
                                   / _|
  __ _ _   _ _ __ ___  _ __ __ _  | |_ ___  ___ ___
 / _` | | | | '__/ _ \| '__/ _` | |  _/ _ \/ __/ __|
| (_| | |_| | | | (_) | | | (_| | | || (_) \__ \__ \
 \__,_|\__,_|_|  \___/|_|  \__,_| |_| \___/|___/___/

Copyright (C) 2018-2019 Aurora Free Open Source Software.

This file is part of the Aurora Free Open Source Software. This
organization promote free and open source software that you can
redistribute and/or modify under the terms of the GNU Lesser General
Public License Version 3 as published by the Free Software Foundation or
(at your option) any later version approved by the Aurora Free Open Source
Software Organization. The license is available in the package root path
as 'LICENSE' file. Please review the following information to ensure the
GNU Lesser General Public License version 3 requirements will be met:
https://www.gnu.org/licenses/lgpl.html .

Alternatively, this file may be used under the terms of the GNU General
Public License version 3 or later as published by the Free Software
Foundation. Please review the following information to ensure the GNU
General Public License requirements will be met:
http://www.gnu.org/licenses/gpl-3.0.html.

NOTE: All products, services or anything associated to trademarks and
service marks used or referenced on this file are the property of their
respective companies/owners or its subsidiaries. Other names and brands
may be claimed as the property of others.

For more info about intellectual property visit: aurorafoss.org or
directly send an email to: contact (at) aurorafoss.org .
*/

module riverd.xcursor.dynload;

public import riverd.loader;

public import riverd.xcursor.dynfun;

version(D_BetterC)
{
	void* dylib_load_xcursor() {
		version(Cygwin) void* handle = dylib_load("libXcursor-1.so");
		else {
			void* handle = dylib_load("libXcursor.so");
			if(handle is null) handle = dylib_load("libXcursor.so.1");
		}

		if(handle is null) return null;

		dylib_bindSymbol(handle, cast(void**)&XcursorImageCreate, "XcursorImageCreate");
		dylib_bindSymbol(handle, cast(void**)&XcursorImageDestroy, "XcursorImageDestroy");
		dylib_bindSymbol(handle, cast(void**)&XcursorImagesCreate, "XcursorImagesCreate");
		dylib_bindSymbol(handle, cast(void**)&XcursorImagesDestroy, "XcursorImagesDestroy");
		dylib_bindSymbol(handle, cast(void**)&XcursorImageLoadCursor, "XcursorImageLoadCursor");

		return handle;
	}
}
else
{
	version(Cygwin) private enum string[] _xcursor_libs = ["libXcursor-1.so"];
	else private enum string[] _xcursor_libs = ["libXcursor.so", "libXcursor.so.1"];

	mixin(DylibLoaderBuilder!("Xcursor", _xcursor_libs, riverd.xcursor.dynfun));
}

unittest {
	void* xcursor_handle = dylib_load_xcursor();
	assert(dylib_is_loaded(xcursor_handle));

	dylib_unload(xcursor_handle);
}
