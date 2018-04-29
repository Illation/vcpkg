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
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/adt-0.3.0)
vcpkg_download_distfile(ARCHIVE
    URLS "https://gitlab.com/mojofunk/adt/-/archive/0.3.0/adt-0.3.0.tar.gz"
    FILENAME "adt-0.3.0.tar.gz"
    SHA512 350e614fb934d26a517cc95789bac5b7d58d1e289841603e1c5be7afc79cd4831544ae1f5bcb732f375f7f7921d74057f68db591ca862969ec12e116acc7d049 
)

vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    OPTIONS -DBUILD_SHARED_LIBS=1 -DBUILD_TESTS=OFF
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

vcpkg_copy_pdbs()

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE.GPLv3 DESTINATION ${CURRENT_PACKAGES_DIR}/share/adt RENAME copyright)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

file(COPY ${CURRENT_PACKAGES_DIR}/include/adt-0/adt.hpp DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(COPY ${CURRENT_PACKAGES_DIR}/include/adt-0/adt-private.hpp DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(COPY ${CURRENT_PACKAGES_DIR}/include/adt-0/adt DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(COPY ${CURRENT_PACKAGES_DIR}/include/adt-0/adt/private DESTINATION ${CURRENT_PACKAGES_DIR}/include/adt)
file(COPY ${CURRENT_PACKAGES_DIR}/include/adt-0/moodycamel DESTINATION ${CURRENT_PACKAGES_DIR}/include/)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/adt-0)
