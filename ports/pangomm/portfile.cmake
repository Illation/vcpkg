# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/pangomm-2.40.1)
vcpkg_download_distfile(ARCHIVE
    URLS "http://ftp.gnome.org/pub/GNOME/sources/pangomm/2.40/pangomm-2.40.1.tar.xz"
    FILENAME "pangomm-2.40.1.tar.xz"
    SHA512 bed19800b76e69cc51abeb5997bdc2f687f261ebcbe36aeee51f1fbf5010a46f4b9469033c34a912502001d9985135fd5c7f7574d3de8ba33cc5832520c6aa6f
)
vcpkg_extract_source_archive(${ARCHIVE})

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

file(
    COPY ${CMAKE_CURRENT_LIST_DIR}/pangommconfig.h.cmakein
    DESTINATION ${SOURCE_PATH}/pango
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

vcpkg_copy_pdbs()

set(PANGOMM_TARGET pangomm-1.4)

# Move Headers
file(
    RENAME ${CURRENT_PACKAGES_DIR}/include/${PANGOMM_TARGET}/pangomm/
    ${CURRENT_PACKAGES_DIR}/include/pangomm
)

file(
    COPY ${CURRENT_PACKAGES_DIR}/include/${PANGOMM_TARGET}/
    DESTINATION ${CURRENT_PACKAGES_DIR}/include
    FILES_MATCHING PATTERN *.h
)

file(
    RENAME ${CURRENT_PACKAGES_DIR}/lib/${PANGOMM_TARGET}/include/pangommconfig.h
    ${CURRENT_PACKAGES_DIR}/include/pangommconfig.h
)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib/${PANGOMM_TARGET})

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/${PANGOMM_TARGET})

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)


# Handle copyright and readme
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/pangomm RENAME copyright)
file(INSTALL ${SOURCE_PATH}/README DESTINATION ${CURRENT_PACKAGES_DIR}/share/pangomm RENAME readme.txt)
