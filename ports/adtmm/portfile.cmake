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
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/adtmm-0.3.0)
vcpkg_download_distfile(ARCHIVE
    URLS "https://gitlab.com/mojofunk/adtmm/-/archive/0.3.0/adtmm-0.3.0.tar.gz"
    FILENAME "adtmm-0.3.0.tar.gz"
    SHA512 04ba3bfff69510590d607b2159d4fda75be3a639d70bd2bf14083752630173d53b6cdb4926729c2afbc4d8198c63a6568d83656538bb86d54edf950dfa59a6f4
)
vcpkg_extract_source_archive(${ARCHIVE})

# Override the default dependencies
file(
    INSTALL ${CMAKE_CURRENT_LIST_DIR}/AdtmmDependenciesVcpkg.cmake
    DESTINATION ${SOURCE_PATH}/CMakeScripts RENAME AdtmmDependencies.cmake
)

# Override the default install
file(
    INSTALL ${CMAKE_CURRENT_LIST_DIR}/AdtmmInstallVcpkg.cmake
    DESTINATION ${SOURCE_PATH}/CMakeScripts RENAME AdtmmInstall.cmake
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    OPTIONS_DEBUG -DINSTALL_HEADERS=OFF
)

vcpkg_install_cmake()

vcpkg_copy_pdbs()

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE.GPLv3 DESTINATION ${CURRENT_PACKAGES_DIR}/share/adtmm RENAME copyright)
