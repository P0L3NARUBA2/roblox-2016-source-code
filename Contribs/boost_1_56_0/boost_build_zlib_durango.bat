@echo off
setlocal EnableDelayedExpansion

call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" x64

set "XDK_ROOT=C:\Program Files (x86)\Microsoft Durango XDK\160801\xdk"
set "Console_SdkRoot=!XDK_ROOT!\"
set "Console_SdkIncludeRoot=!XDK_ROOT!\include\"
set "Console_SdkLibPath=!XDK_ROOT!\lib\amd64\"


for %%F in (.) do set "BOOST_ROOT=%%~dpnxF"
set "ZLIB_SRC=!BOOST_ROOT!\..\windows\x86\zlib\zlib-1.2.8"
set "OUTPUT_DIR=!BOOST_ROOT!\stage\lib\durango"

if not exist "!OUTPUT_DIR!" mkdir "!OUTPUT_DIR!"

if exist "C:\temp\zlib-durango-build" rmdir /s /q "C:\temp\zlib-durango-build" 2>nul
mkdir "C:\temp\zlib-durango-build"

echo.
echo === Compiling zlib with Durango x64 toolchain ===
echo Source: !ZLIB_SRC!
echo Output: !OUTPUT_DIR!

cl.exe ^
    /c /O2 /MT /W3 /GS- ^
    /D "RBX_PLATFORM_WIN_DURANGO" ^
    /D "ZLIB_WINAPI" ^
    /D "WIN32" ^
    /D "_WIN32_WINNT=0x0603" ^
    /D "_CRT_SECURE_NO_WARNINGS" ^
    /D "_CRT_NONSTDC_NO_DEPRECATE" ^
    /D "_CRT_SECURE_NO_DEPRECATE" ^
    /D "_SCL_SECURE_NO_DEPRECATE" ^
    /I"!Console_SdkIncludeRoot!um" ^
    /I"!Console_SdkIncludeRoot!shared" ^
    /I"!Console_SdkIncludeRoot!winrt" ^
    /I"!ZLIB_SRC!" ^
    /Fo"C:\temp\zlib-durango-build\\" ^
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
    echo ERROR: Failed to compile zlib sources!
    pause
    exit /b 1
)

echo.
echo === Creating static library with Boost naming ===

lib.exe /OUT:"!OUTPUT_DIR!\libboost_zlib-vc110-mt-1_56.lib" ^
    "C:\temp\zlib-durango-build\*.obj"

if errorlevel 1 (
    echo ERROR: Failed to create zlib library!
    pause
    exit /b 1
)

:: Cleanup
rmdir /s /q "C:\temp\zlib-durango-build" 2>nul

echo.
echo === Build Complete ===
echo Output: !OUTPUT_DIR!\libboost_zlib-vc110-mt-1_56.lib
dir "!OUTPUT_DIR!\libboost_zlib-vc110-mt-1_56.lib"

echo.
echo === Next Steps ===
echo Update build_boost_durango.bat:
echo   1. Remove: :: DO NOT set ZLIB_BINARY
echo   2. Add: set "ZLIB_BINARY=!BOOST_ROOT!\stage\lib\durango"
echo   3. Add: set "ZLIB_INCLUDE=!ZLIB_SRC!"
echo   4. Add to b2 command: -s ZLIB_BINARY=!BOOST_ROOT!\stage\lib\durango
echo.
pause