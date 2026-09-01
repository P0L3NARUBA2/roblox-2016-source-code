@echo off
setlocal EnableDelayedExpansion

:: Setup VS2012 x64 environment
call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" x64

set "XDK_ROOT=C:\Program Files (x86)\Microsoft Durango XDK\160801\xdk"
set "Console_SdkRoot=!XDK_ROOT!\"
set "Console_SdkIncludeRoot=!XDK_ROOT!\include\"
set "Console_SdkLibPath=!XDK_ROOT!\lib\amd64\"

echo Building Boost 1.56.0 + zlib for Xbox One Durango x64

:: THOROUGH CLEAN - Remove ALL cached build state
echo Cleaning previous build state...
if exist "bin.v2" rmdir /s /q "bin.v2" 2>nul
if exist "stage" rmdir /s /q "stage" 2>nul
if exist "C:\temp\boostbuild" rmdir /s /q "C:\temp\boostbuild" 2>nul
if exist "C:\temp\durango-zlib-build" rmdir /s /q "C:\temp\durango-zlib-build" 2>nul

:: Recreate directories
if not exist "C:\temp" mkdir "C:\temp"
mkdir "C:\temp\boostbuild"
mkdir "stage\lib\durango"

for %%F in (.) do set "BOOST_ROOT=%%~dpnxF"

:: Set ZLIB environment variables BEFORE any b2 calls
set "ZLIB_ROOT=!BOOST_ROOT!\..\windows\x86\zlib\zlib-1.2.8"
set "ZLIB_SOURCE=!ZLIB_ROOT!"
set "ZLIB_INCLUDE=!ZLIB_ROOT!"
:: DO NOT set ZLIB_BINARY - it triggers prebuilt mode

echo ZLIB_SOURCE=!ZLIB_SOURCE!
echo.

:: RELEASE BUILD with zlib
echo === Building RELEASE x64 with zlib ===

b2.exe -a ^
    --build-dir=C:\temp\boostbuild ^
    --stagedir=stage/durango ^
    toolset=msvc-11.0durango ^
    variant=release ^
    address-model=64 ^
    architecture=x86 ^
    link=static ^
    threading=multi ^
    runtime-link=shared ^
    --with-chrono ^
    --with-filesystem ^
    --with-iostreams ^
    --with-system ^
    --with-thread ^
    --with-atomic ^
    --with-date_time ^
    --with-regex ^
    --with-random ^
    --with-serialization ^
    --with-program_options ^
    --with-timer ^
    define=RBX_PLATFORM_WIN_DURANGO ^
    define=BOOST_CXX11_NO_DELETED_FUNCTIONS ^
    define=_CRT_SECURE_NO_WARNINGS ^
    define=ZLIB_WINAPI ^
    cxxflags=/arch:AVX ^
    cxxflags=/GS- ^
    -j4 ^
    stage

if errorlevel 1 (
    echo ERROR: Release build failed!
    pause
    exit /b 1
)

move /y "stage\durango\lib\*.lib" "stage\lib\durango\" 2>nul
rmdir /s /q "C:\temp\boostbuild" 2>nul

echo.
echo === Build Complete ===
echo Checking for zlib library...
dir "stage\lib\durango\*zlib*.lib" 2>nul || echo WARNING: No zlib library found!
dir "stage\lib\durango\*.lib" 2>nul
pause