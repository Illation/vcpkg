cmake_minimum_required(VERSION 3.4)

include(GnuInstallDirs)

project(atkmm)

set(ATKMM_VERSION_MAJOR  2)
set(ATKMM_VERSION_MINOR  24)
set(ATKMM_VERSION_MICRO  2)

set(ATKMM_VERSION ${ATKMM_VERSION_MAJOR}.${ATKMM_VERSION_MINOR}.${ATKMM_VERSION_MICRO})

# Be consistent with the library names on all platforms
set(ATKMM_TARGET atkmm-1.6)

find_package(PkgConfig)

if(PKG_CONFIG_FOUND)
    pkg_check_modules(ATKMM_DEPS atk glib-2.0)
endif()

if (NOT ATKMM_DEPS_FOUND)
    message("pkg-config not found, falling back on manual dependency discovery")

    find_path(ATK_INCLUDE_DIRS atk/atk.h)
    find_path(GLIB_INCLUDE_DIRS glib.h)
    find_path(GOBJECT_INCLUDE_DIRS glib-object.h)
    find_path(GLIBMM_INCLUDE_DIRS glibmm.h)
    find_path(SIGCPP_INCLUDE_DIRS sigc++/sigc++.h)

    find_library(GLIB_LIBRARIES glib-2.0)
    find_library(GOBJECT_LIBRARIES gobject-2.0)
    # vcpkg ATOW has some incorrect lib names
    find_library(ATK_LIBRARIES NAMES atk-1.6 atk-1.0)
    find_library(GLIBMM_LIBRARIES NAMES glibmm-2.4 glibmm)
    find_library(SIGCPP_LIBRARIES sigc-2.0)

    set(ATKMM_DEPS_INCLUDE_DIRS
        ${GLIB_INCLUDE_DIRS}
        ${GOBJECT_INCLUDE_DIRS}
        ${ATK_INCLUDE_DIRS}
        ${GLIBMM_INCLUDE_DIRS}
        ${SIGCPP_INCLUDE_DIRS}
    )

    set(ATKMM_DEPS_LIBRARIES
        ${GLIB_LIBRARIES}
        ${GOBJECT_LIBRARIES}
        ${ATK_LIBRARIES}
        ${GLIBMM_LIBRARIES}
        ${SIGCPP_LIBRARIES}
    )
endif()

configure_file(atk/atkmmconfig.h.cmakein atkmmconfig.h)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

SET(ATKMM_SOURCES
    atk/atkmm/action.cc
    atk/atkmm/component.cc
    atk/atkmm/document.cc
    atk/atkmm/editabletext.cc
    atk/atkmm/hyperlink.cc
    atk/atkmm/hypertext.cc
    atk/atkmm/image.cc
    atk/atkmm/implementor.cc
    atk/atkmm/init.cc
    atk/atkmm/noopobject.cc
    atk/atkmm/object.cc
    atk/atkmm/objectaccessible.cc
    atk/atkmm/range.cc
    atk/atkmm/relation.cc
    atk/atkmm/relationset.cc
    atk/atkmm/selection.cc
    atk/atkmm/stateset.cc
    atk/atkmm/streamablecontent.cc
    atk/atkmm/table.cc
    atk/atkmm/text.cc
    atk/atkmm/value.cc
    atk/atkmm/wrap_init.cc
)

# In case we need to add these to sources later
#[[
SET(ATKMM_HEADERS
    atk/atkmm/action.h
    atk/atkmm/component.h
    atk/atkmm/document.h
    atk/atkmm/editabletext.h
    atk/atkmm/hyperlink.h
    atk/atkmm/hypertext.h
    atk/atkmm/image.h
    atk/atkmm/implementor.h
    atk/atkmm/init.h
    atk/atkmm/noopobject.h
    atk/atkmm/object.h
    atk/atkmm/objectaccessible.h
    atk/atkmm/range.h
    atk/atkmm/relation.h
    atk/atkmm/relationset.h
    atk/atkmm/selection.h
    atk/atkmm/stateset.h
    atk/atkmm/streamablecontent.h
    atk/atkmm/table.h
    atk/atkmm/text.h
    atk/atkmm/value.h
    atk/atkmm/wrap_init.h
)
#]]

file(GLOB ATKMM_HEADERS "atk/*.h")
file(GLOB ATKMM_SUBHEADERS "atk/atkmm/*.h")

add_library(${ATKMM_TARGET} ${ATKMM_SOURCES})

set_target_properties(${ATKMM_TARGET} PROPERTIES
    CXX_STANDARD 11
    CXX_STANDARD_REQUIRED YES
    CXX_EXTENSIONS NO
)

if(BUILD_SHARED_LIBS)
    if (MSVC)
        message("MSVC detected, exporting all symbols from DLL")
        set_target_properties(
            ${ATKMM_TARGET}
            PROPERTIES WINDOWS_EXPORT_ALL_SYMBOLS true
        )
        #set_target_properties(${ATKMM_TARGET} PROPERTIES DEBUG_POSTFIX d)
    endif()
    target_compile_definitions(${ATKMM_TARGET} PRIVATE "ATKMM_DLL" "ATKMM_BUILD")
else()
    target_compile_definitions(${ATKMM_TARGET} PRIVATE "ATKMM_STATIC_LIB")
endif()

target_include_directories(${ATKMM_TARGET} PUBLIC atk ${ATKMM_DEPS_INCLUDE_DIRS})

target_link_libraries(${ATKMM_TARGET} PUBLIC ${ATKMM_DEPS_LIBRARIES})

install(
    TARGETS ${ATKMM_TARGET}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

install(
    FILES ${ATKMM_HEADERS}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${ATKMM_TARGET}
)

install(
    FILES ${ATKMM_SUBHEADERS}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${ATKMM_TARGET}/atkmm
)

install(
    FILES "${CMAKE_CURRENT_BINARY_DIR}/atkmmconfig.h"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/${ATKMM_TARGET}/include"
)
