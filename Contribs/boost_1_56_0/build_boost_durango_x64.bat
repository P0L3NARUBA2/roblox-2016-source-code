@echo off
setlocal

echo Building Boost 1.56.0 for Windows x64 (VS2012 vc110)

:: Setup VS2012 x64 environment
call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" x64

if errorlevel 1 (
    echo ERROR: VS2012 not found. Modify path if using different VS version.
    pause
    exit /b 1
)

:: Create output directory
if not exist "stage\lib\x64" mkdir "stage\lib\x64"

:: RELEASE BUILD
echo.
echo === Building RELEASE x64 ===

b2.exe stage ^
    -a ^
    --reconfigure ^
    --toolset=msvc-11.0 ^
    --variant=release ^
    --address-model=64 ^
    --architecture=x86 ^
    --link=static ^
    --threading=multi ^
    --runtime-link=shared ^
    --libdir=stage/lib/x64 ^
    --includedir=include ^
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
    --with-signals ^
    -s ZLIB_SOURCE=%CD%\..\windows\x86\zlib\zlib-1.2.8 ^
    -s ZLIB_BINARY=%CD%\..\windows\x86\zlib\zlib-1.2.8\lib\release ^
    define=ZLIB_WINAPI ^
    define=_WIN32_WINNT=0x0501 ^
    cxxflags=/arch:SSE2 ^
    cxxflags=/fp:fast ^
    -j4

:: DEBUG BUILD
echo.
echo === Building DEBUG x64 ===

b2.exe stage ^
    -a ^
    --reconfigure ^
    --toolset=msvc-11.0 ^
    --variant=debug ^
    --address-model=64 ^
    --architecture=x86 ^
    --link=static ^
    --threading=multi ^
    --runtime-link=shared ^
    --libdir=stage/lib/x64 ^
    --includedir=include ^
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
    --with-signals ^
    -s ZLIB_SOURCE=%CD%\..\windows\x86\zlib\zlib-1.2.8 ^
    -s ZLIB_BINARY=%CD%\..\windows\x86\zlib\zlib-1.2.8\lib ^
    define=ZLIB_WINAPI ^
    define=_WIN32_WINNT=0x0501 ^
    cxxflags=/arch:SSE2 ^
    -j4

echo.
echo === Build Complete ===
echo Libraries: stage/lib/x64/
echo.
echo Naming convention:
echo   Release: libboost_*-vc110-mt-1_56.lib
echo   Debug:   libboost_*-vc110-mt-gd-1_56.lib
pause