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
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/adtmm-0.2.0)
vcpkg_download_distfile(ARCHIVE
    URLS "https://gitlab.com/mojofunk/adtmm/-/archive/0.2.0/adtmm-0.2.0.tar.gz"
    FILENAME "adtmm-0.2.0.tar.gz"
    SHA512 51593063b278061e62782638acc18385304c2344cb32a62a02e92e7c5b41106e2349767b9d9bb9841e43a7e517edee4c0724cec7121746c584eb0ef9430c0a3a 
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

vcpkg_copy_pdbs()

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE.GPLv3 DESTINATION ${CURRENT_PACKAGES_DIR}/share/adtmm RENAME copyright)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

file(COPY ${CURRENT_PACKAGES_DIR}/include/adtmm-3/adtmm.hpp DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(COPY ${CURRENT_PACKAGES_DIR}/include/adtmm-3/adtmm-private.hpp DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(COPY ${CURRENT_PACKAGES_DIR}/include/adtmm-3/adtmm/ DESTINATION ${CURRENT_PACKAGES_DIR}/include/adtmm)
file(COPY ${CURRENT_PACKAGES_DIR}/include/adtmm-3/adtmm/private DESTINATION ${CURRENT_PACKAGES_DIR}/include/adtmm)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/adtmm-3)
