@echo off
setlocal


if not exist "stage\lib\x64" mkdir "stage\lib\x64"

:: RELEASE BUILD
echo.
echo === Building RELEASE x64 ===

b2.exe --stagedir=stage/lib/x64 stage ^
    -a ^
    --reconfigure ^
    --toolset=msvc-12.0 ^
    architecture=x86 ^
    address-model=64 ^
    --variant=release ^
    --link=static ^
    --threading=multi ^
    --runtime-link=shared ^
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
    -j4

:: DEBUG BUILD
echo.
echo === Building DEBUG x64 ===

b2.exe --stagedir=stage/lib/x64 stage ^
    -a ^
    --reconfigure ^
    --toolset=msvc-12.0 ^
    architecture=x86 ^
    address-model=64 ^
    --variant=debug ^
    --link=static ^
    --threading=multi ^
    --runtime-link=shared ^
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
    -j4

echo.
echo === Build Complete ===
echo Libraries: stage/lib/x64/
echo.
echo Naming convention:
echo   Release: libboost_*-vc110-mt-1_56.lib
echo   Debug:   libboost_*-vc110-mt-gd-1_56.lib
pause