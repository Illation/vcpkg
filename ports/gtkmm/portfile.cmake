# Glibmm uses winapi functions not available in WindowsStore, so gtkmm
# also
if (VCPKG_CMAKE_SYSTEM_NAME STREQUAL WindowsStore)
message(FATAL_ERROR "Error: UWP builds are currently not supported.")
endif()

# Glibmm relies on DllMain, so gtkmm also
if (VCPKG_LIBRARY_LINKAGE STREQUAL static)
message(STATUS "Warning: Static building not supported. Building dynamic.")
set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/gtkmm-3.22.2)
vcpkg_download_distfile(ARCHIVE
    URLS "http://ftp.gnome.org/pub/GNOME/sources/gtkmm/3.22/gtkmm-3.22.2.tar.xz"
    FILENAME "gtkmm-3.22.2.tar.xz"
    SHA512 6e96b543e459481145ee0f56f31a7ad2466bd8ccdd2abf3205998aecede73d235149ca6e5ba6e8d20a4fd5345e310870d81ac2a716d4f78d1460ed685badbdc2
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/fix_properties.patch
        ${CMAKE_CURRENT_LIST_DIR}/fix_charset.patch
        ${CMAKE_CURRENT_LIST_DIR}/remove_export_macro.patch
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

file(COPY ${CMAKE_CURRENT_LIST_DIR}/gdkmmconfig.h.cmake DESTINATION ${SOURCE_PATH}/gdk)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/gtkmmconfig.h.cmake DESTINATION ${SOURCE_PATH}/gtk)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright and readme
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/gtkmm RENAME copyright)
file(INSTALL ${SOURCE_PATH}/README DESTINATION ${CURRENT_PACKAGES_DIR}/share/gtkmm RENAME readme.txt)
