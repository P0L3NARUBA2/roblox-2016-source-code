# Cookbook for CONTRIBS:

## You Don't need to Build the Contribs Folder Anymore cuz i Replaced it with a Fixed And Prebuilt version, Follow these Steps Instead:
1. Extract the Contribs Folder: https://www.mediafire.com/file/w9arcravtbdyskl/Contribs.zip/file
2. Create a new folder named openssl inside Trunk2016
3. When the build process completes, go inside Contribs\openssl\out32dll, and copy these 2 files to Trunk2016\openssl: ssleay32.dll, libeay32.dll.
## SDL2
To build SDL2 as a .DLL file, just change the **Target Extension** to **.dll** and **Configuration Type** to **Dynamic Library (.dll)**, remove the **HAVE_LIBC** preprocessor from the properties and build it!<br>
However if you want to build as .LIB, then you dont have to change anything just build it.

## libcurl
If you also need to build libcurl as a .LIB file, Just change the **Target Extention** to **.lib** and **Configuration Type** to **Static Library (.lib)** and Build it!
However if you want to build as .DLL, then also you dont have to change anything just build it.

**That's it, you've compiled the libraries!**<br>
**Also, you may want to change the library files in the source with yours.**
