# ATK uses DllMain, so atkmm also
if (VCPKG_LIBRARY_LINKAGE STREQUAL static)
    message(STATUS "Warning: Static building not supported. Building dynamic.")
    set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/atkmm-2.24.2)
vcpkg_download_distfile(ARCHIVE
    URLS "http://ftp.gnome.org/pub/GNOME/sources/atkmm/2.24/atkmm-2.24.2.tar.xz"
    FILENAME "atkmm-2.24.2.tar.xz"
    SHA512 427714cdf3b10e3f9bc36df09c4b05608d295f5895fb1e079b9bd84afdf7bf1cfdec6794ced7f1e35bd430b76f87792df4ee63c515071a2ea6e3e51e672cdbe2
)
vcpkg_extract_source_archive(${ARCHIVE})

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

file(
    COPY ${CMAKE_CURRENT_LIST_DIR}/atkmmconfig.h.cmakein
    DESTINATION ${SOURCE_PATH}/atk
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

set(ATKMM_TARGET atkmm-1.6)

# Move Headers
file(
    RENAME ${CURRENT_PACKAGES_DIR}/include/${ATKMM_TARGET}/atkmm/
    ${CURRENT_PACKAGES_DIR}/include/atkmm
)

file(
    COPY ${CURRENT_PACKAGES_DIR}/include/${ATKMM_TARGET}/
    DESTINATION ${CURRENT_PACKAGES_DIR}/include
    FILES_MATCHING PATTERN *.h
)

file(
    RENAME ${CURRENT_PACKAGES_DIR}/lib/${ATKMM_TARGET}/include/atkmmconfig.h
    ${CURRENT_PACKAGES_DIR}/include/atkmmconfig.h
)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib/${ATKMM_TARGET})

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/${ATKMM_TARGET})

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright and readme
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/atkmm RENAME copyright)
file(INSTALL ${SOURCE_PATH}/README DESTINATION ${CURRENT_PACKAGES_DIR}/share/atkmm RENAME readme.txt)
