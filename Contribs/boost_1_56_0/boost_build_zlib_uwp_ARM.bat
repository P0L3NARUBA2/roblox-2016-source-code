@echo off
setlocal EnableDelayedExpansion


for %%F in (.) do set "BOOST_ROOT=%%~dpnxF"
set "ZLIB_SRC=!BOOST_ROOT!\..\windows\x86\zlib\zlib-1.2.8"
set "OUTPUT_DIR=!BOOST_ROOT!\stage\lib\ARM\lib"

if not exist "!OUTPUT_DIR!" mkdir "!OUTPUT_DIR!"

if exist "C:\temp\zlib-uwp-build" rmdir /s /q "C:\temp\zlib-uwp-build" 2>nul
mkdir "C:\temp\zlib-uwp-build"
mkdir "C:\temp\zlib-uwp-build\debug"
mkdir "C:\temp\zlib-uwp-build\release"

echo.
echo Source: !ZLIB_SRC!
echo Output: !OUTPUT_DIR!

echo.
echo === Building DEBUG version (mt-gd) ===

cl.exe ^
    /c /Od /MDd /W3 /GS- /Z7 ^
    /D "RBX_PLATFORM_WIN_UWP" ^
    /D "ZLIB_WINAPI" ^
    /D "WIN32" ^
    /D "_WIN32_WINNT=0x0603" ^
    /D "_CRT_SECURE_NO_WARNINGS" ^
    /D "_CRT_NONSTDC_NO_DEPRECATE" ^
    /D "_CRT_SECURE_NO_DEPRECATE" ^
    /D "_SCL_SECURE_NO_DEPRECATE" ^
    /D "WINAPI_FAMILY=WINAPI_FAMILY_APP" ^
    /D "_DEBUG" ^
    /I"!ZLIB_SRC!" ^
    /Fo"C:\temp\zlib-uwp-build\debug\\" ^
    "!ZLIB_SRC!\adler32.c" ^
    "!ZLIB_SRC!\compress.c" ^
    "!ZLIB_SRC!\crc32.c" ^
    "!ZLIB_SRC!\deflate.c" ^
    "!ZLIB_SRC!\gzclose.c" ^
    "!ZLIB_SRC!\gzlib.c" ^
    "!ZLIB_SRC!\gzread.c" ^
    "!ZLIB_SRC!\gzwrite.c" ^
    "!ZLIB_SRC!\infback.c" ^
    "!ZLIB_SRC!\inffast.c" ^
    "!ZLIB_SRC!\inflate.c" ^
    "!ZLIB_SRC!\inftrees.c" ^
    "!ZLIB_SRC!\trees.c" ^
    "!ZLIB_SRC!\uncompr.c" ^
    "!ZLIB_SRC!\zutil.c"

if errorlevel 1 (
    echo ERROR: Failed to compile zlib debug sources!
    pause
    exit /b 1
)

lib.exe /OUT:"!OUTPUT_DIR!\libboost_zlib-vc120-mt-gd-1_56.lib" ^
    "C:\temp\zlib-uwp-build\debug\*.obj"

if errorlevel 1 (
    echo ERROR: Failed to create zlib debug library!
    pause
    exit /b 1
)

echo.
echo === Building RELEASE version (mt) ===

cl.exe ^
    /c /O2 /MD /W3 /GS- ^
    /D "RBX_PLATFORM_WIN_UWP" ^
    /D "ZLIB_WINAPI" ^
    /D "WIN32" ^
    /D "_WIN32_WINNT=0x0603" ^
    /D "_CRT_SECURE_NO_WARNINGS" ^
    /D "_CRT_NONSTDC_NO_DEPRECATE" ^
    /D "_CRT_SECURE_NO_DEPRECATE" ^
    /D "_SCL_SECURE_NO_DEPRECATE" ^
    /D "WINAPI_FAMILY=WINAPI_FAMILY_APP" ^
    /D "NDEBUG" ^
    /I"!ZLIB_SRC!" ^
    /Fo"C:\temp\zlib-uwp-build\release\\" ^
    "!ZLIB_SRC!\adler32.c" ^
    "!ZLIB_SRC!\compress.c" ^
    "!ZLIB_SRC!\crc32.c" ^
    "!ZLIB_SRC!\deflate.c" ^
    "!ZLIB_SRC!\gzclose.c" ^
    "!ZLIB_SRC!\gzlib.c" ^
    "!ZLIB_SRC!\gzread.c" ^
    "!ZLIB_SRC!\gzwrite.c" ^
    "!ZLIB_SRC!\infback.c" ^
    "!ZLIB_SRC!\inffast.c" ^
    "!ZLIB_SRC!\inflate.c" ^
    "!ZLIB_SRC!\inftrees.c" ^
    "!ZLIB_SRC!\trees.c" ^
    "!ZLIB_SRC!\uncompr.c" ^
    "!ZLIB_SRC!\zutil.c"

if errorlevel 1 (
    echo ERROR: Failed to compile zlib release sources!
    pause
    exit /b 1
)

lib.exe /OUT:"!OUTPUT_DIR!\libboost_zlib-vc120-mt-1_56.lib" ^
    "C:\temp\zlib-uwp-build\release\*.obj"

if errorlevel 1 (
    echo ERROR: Failed to create zlib release library!
    pause
    exit /b 1
)

:: Cleanup
rmdir /s /q "C:\temp\zlib-uwp-build" 2>nul

echo.
echo === Build Complete ===
echo Output: !OUTPUT_DIR!\libboost_zlib-vc120-mt-1_56.lib
echo Output: !OUTPUT_DIR!\libboost_zlib-vc120-mt-gd-1_56.lib
dir "!OUTPUT_DIR!\libboost_zlib-vc120-mt-*.lib"

echo.
echo === Next Steps ===
echo Update build_boost_durango.bat:
echo   1. Remove: :: DO NOT set ZLIB_BINARY
echo   2. Add: set "ZLIB_BINARY=!BOOST_ROOT!\stage\lib\durango"
echo   3. Add: set "ZLIB_INCLUDE=!ZLIB_SRC!"
echo   4. Add to b2 command: -s ZLIB_BINARY=!BOOST_ROOT!\stage\lib\durango
echo.
pause