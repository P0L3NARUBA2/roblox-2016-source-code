@echo off

call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" x64

set "XDK_ROOT=C:\Program Files (x86)\Microsoft Durango XDK\160801\xdk"
set "Console_SdkRoot=!XDK_ROOT!\"
set "Console_SdkIncludeRoot=!XDK_ROOT!\include\"
set "Console_SdkLibPath=!XDK_ROOT!\lib\amd64\"


b2 stage ^
-a ^
--reconfigure ^
--toolset=msvc-11.0durango ^
--variant=release ^
    address-model=64 ^
    architecture=x86 ^
    define=BOOST_CXX11_NO_DELETED_FUNCTIONS ^
    cxxflags=/arch:AVX ^
    cxxflags=/GS- ^
-s ZLIB_SOURCE=%CONTRIB_PATH%\windows\x86\zlib\zlib-1.2.8 ^
-s ZLIB_BINARY=%CONTRIB_PATH%\windows\x86\zlib\zlib-1.2.8\lib\release ^
--prefix=%CONTRIB_PATH%\boost_1_56_0 ^
--libdir=%CONTRIB_PATH%\boost_1_56_0\lib ^
--includedir=%CONTRIB_PATH%\boost_1_56_0\include

PAUSE
