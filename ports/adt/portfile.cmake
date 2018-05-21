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
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/adt-0.5.0)
vcpkg_download_distfile(ARCHIVE
    URLS "https://gitlab.com/mojofunk/adt/-/archive/0.5.0/adt-0.5.0.tar.gz"
    FILENAME "adt-0.5.0.tar.gz"
    SHA512 853fb6c7ffd3ab43778378b330d7865bc78db97ecf4c6efddab122cc8eb03eec106881c6d932af989218a841c8f5bc4e4761c53eb1d52e07b26e0cfb1deaab02
)

vcpkg_extract_source_archive(${ARCHIVE})

# Override the default install
file(
    INSTALL ${CMAKE_CURRENT_LIST_DIR}/AdtInstallVcpkg.cmake
    DESTINATION ${SOURCE_PATH}/CMakeScripts RENAME AdtInstall.cmake
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS -DBUILD_SHARED_LIBS=1 -DBUILD_TESTS=OFF
    # OPTIONS_RELEASE -DOPTIMIZE=1
    OPTIONS_DEBUG -DINSTALL_HEADERS=OFF
)

vcpkg_install_cmake()

vcpkg_copy_pdbs()

# Handle copyright
file(
    INSTALL ${SOURCE_PATH}/LICENSE.GPLv3
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/adt RENAME copyright
)
