CMAKE_MINIMUM_REQUIRED(VERSION 2.8.6 FATAL_ERROR)
PROJECT(unrar CXX)

# TODO: (kwk) include libarchive directories here, so unrar can find
# everything needed to implement the file.hpp and file.cpp.
# INCLUDE_DIRECTORIES()

# This list includes what is called the "lib" target in unrar's own makefile
set(unrar_SRCS
    # what is called UNRAR_OBJ in unrar's own makefile
    # we don't want to compile the "unrar" executable but only the lib
    #
    #   filestr.cpp
    #  recvol.cpp
    #  rs.cpp
    #   scantree.cpp
    #   qopen.cpp
    
    # what is called LIB_OBJ in unrar's own makefile
    filestr.cpp
    scantree.cpp
    dll.cpp
    qopen.cpp
    
    # what is called OBJECTS in unrar's own makefile
    rar.cpp
    strlist.cpp
    strfn.cpp
    pathfn.cpp
    smallfn.cpp
    global.cpp
    file.cpp
    filefn.cpp
    filcreat.cpp
    archive.cpp
    arcread.cpp
    unicode.cpp
    system.cpp
    isnt.cpp
    crypt.cpp
    crc.cpp
    rawread.cpp
    encname.cpp
    resource.cpp
    match.cpp
    timefn.cpp
    rdwrfn.cpp
    consio.cpp
    options.cpp
    errhnd.cpp
    rarvm.cpp
    secpassword.cpp
    rijndael.cpp
    getbits.cpp
    sha1.cpp
    sha256.cpp
    blake2s.cpp
    hash.cpp
    extinfo.cpp
    extract.cpp
    volume.cpp
    list.cpp
    find.cpp
    unpack.cpp
    headers.cpp
    threadpool.cpp
    rs16.cpp
    cmddata.cpp
    ui.cpp
    
    # Additional files to define 
)

add_library(unrar STATIC ${unrar_SRCS})

# This will build the unrar library and not the SFX_MODULE or the executable
set(unrar_common_DEFINES "-DRARDLL")

# This was taken unrar's own makefile to configure for Linux GCC compilation:
#
#     # Linux using GCC
#     CXX=g++
#     CXXFLAGS=-O2
#     LIBFLAGS=-fPIC
#     DEFINES=-D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -DRAR_SMP
#     STRIP=strip
#     LDFLAGS=-pthread
#     DESTDIR=/usr
set(unrar_linux_DEFINES "-fPIC -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -DRAR_SMP")
set(unrar_linux_LINK_FLAGS "-pthread")

# TODO: (kwk) check on windows
set(unrar_windows_DEFINES "")
set(unrar_windows_LINK_FLAGS "")

if(CMAKE_COMPILER_IS_GNUCC)
    set_target_properties(unrar PROPERTIES
        COMPILE_FLAGS "-O2 -w -Wunknown-pragmas ${unrar_common_DEFINES} ${unrar_common_CFLAGS_DEBUG} ${unrar_linux_DEFINES}"
        LINK_FLAGS "${unrar_linux_LINK_FLAGS}"
    )
else()
    SET_TARGET_PROPERTIES(unrar PROPERTIES
        COMPILE_FLAGS "${unrar_common_DEFINES} ${unrar_common_CFLAGS_DEBUG} ${unrar_windows_DEFINES}"
    )
endif()

install(TARGETS unrar DESTINATION .)
install(DIRECTORY . DESTINATION include/ PATTERN *.hpp)

