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
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/adt-0.6.0)
vcpkg_download_distfile(ARCHIVE
    URLS "https://gitlab.com/mojofunk/adt/-/archive/0.6.0/adt-0.6.0.tar.gz"
    FILENAME "adt-0.6.0.tar.gz"
    SHA512 1a8e1b7691487504b47a2f7d8fdc9484fa5962b510117bf18f5f122f0c861166883e154cabfeaa856d59a52f3c58308d5bcc48be2ad1b11299cef3959f7c5e02
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
