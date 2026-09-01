@echo off
setlocal


if not exist "stage\lib\ARM" mkdir "stage\lib\ARM"

:: RELEASE BUILD
echo.
echo === Building RELEASE ARM ===

b2.exe --stagedir=stage/lib/ARM stage ^
    -a ^
    --reconfigure ^
    --toolset=msvc-12.0 ^
    architecture=arm ^
    address-model=32 ^
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
    define=WINAPI_FAMILY=WINAPI_FAMILY_APP ^
    define=RBX_PLATFORM_UWP ^
    define=ZLIB_WINAPI ^
    define=_WIN32_WINNT=0x0602 ^
    define=WINVER=0x0602 ^
    define=_UNICODE ^
    define=UNICODE ^
    -j4

:: DEBUG BUILD
echo.
echo === Building DEBUG ARM ===

b2.exe --stagedir=stage/lib/ARM stage ^
    -a ^
    --reconfigure ^
    --toolset=msvc-12.0 ^
    architecture=arm ^
    address-model=32 ^
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
    define=WINAPI_FAMILY=WINAPI_FAMILY_APP ^
    define=RBX_PLATFORM_UWP ^
    define=ZLIB_WINAPI ^
    define=_WIN32_WINNT=0x0602 ^
    define=WINVER=0x0602 ^
    define=_UNICODE ^
    define=UNICODE ^
    -j4

echo.
echo === Build Complete ===
echo Libraries: stage/lib/ARM/
echo.
echo Naming convention:
echo   Release: libboost_*-vc110-mt-1_56.lib
echo   Debug:   libboost_*-vc110-mt-gd-1_56.lib
pause