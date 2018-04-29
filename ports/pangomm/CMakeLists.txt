cmake_minimum_required(VERSION 3.4)

include(GnuInstallDirs)

project(pangomm)

set(PANGOMM_VERSION_MAJOR  2)
set(PANGOMM_VERSION_MINOR  40)
set(PANGOMM_VERSION_MICRO  1)

set(PANGOMM_VERSION ${PANGOMM_VERSION_MAJOR}.${PANGOMM_VERSION_MINOR}.${PANGOMM_VERSION_MICRO})

# Use a consistent library name on all platforms
set(PANGOMM_TARGET pangomm-1.4)

find_package(PkgConfig)

set(PANGOMM_PKG_DEPS "glibmm-2.4 >= 2.48.0 cairomm-1.0 >= 1.2.2 pangocairo >= 1.38.0")

if(PKG_CONFIG_FOUND)
    pkg_check_modules(PANGOMM_DEPS ${PANGOMM_PKG_DEPS})
endif()

if (NOT PANGOMM_DEPS_FOUND)
    message("pkg-config not found, falling back on manual dependency discovery")

    find_path(GLIB_INCLUDE_DIRS glib.h)
    find_path(GOBJECT_INCLUDE_DIRS glib-object.h)
    find_path(PANGO_INCLUDE_DIRS pango/pango.h)
    find_path(PANGOCAIRO_INCLUDE_DIRS pango/pangocairo.h)
    find_path(GLIBMM_INCLUDE_DIRS glibmm.h)
    find_path(CAIROMM_INCLUDE_DIRS cairomm/cairomm.h)
    find_path(SIGCPP_INCLUDE_DIRS sigc++/sigc++.h)

    find_library(GLIB_LIBRARIES glib-2.0)
    find_library(GOBJECT_LIBRARIES gobject-2.0)
    find_library(PANGOCAIRO_LIBRARIES pangocairo-1.0)
    find_library(PANGO_LIBRARIES pango-1.0)
    find_library(GLIBMM_LIBRARIES NAMES glibmm-2.4 glibmm)
    find_library(CAIROMM_LIBRARIES cairomm-1.0)
    find_library(SIGCPP_LIBRARIES sigc-2.0)

    set(PANGOMM_DEPS_INCLUDE_DIRS
        ${GLIB_INCLUDE_DIRS}
        ${PANGO_INCLUDE_DIRS}
        ${PANGOCAIRO_INCLUDE_DIRS}
        ${CAIROMM_INCLUDE_DIRS}
        ${GOBJECT_INCLUDE_DIRS}
        ${GLIBMM_INCLUDE_DIRS}
        ${SIGCPP_INCLUDE_DIRS}
    )

    set(PANGOMM_DEPS_LIBRARIES
        ${GLIB_LIBRARIES}
        ${PANGO_LIBRARIES}
        ${PANGOCAIRO_LIBRARIES}
        ${CAIROMM_LIBRARIES}
        ${GOBJECT_LIBRARIES}
        ${GLIBMM_LIBRARIES}
        ${SIGCPP_LIBRARIES}
    )
endif()

configure_file(pango/pangommconfig.h.cmakein pangommconfig.h)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

set(PANGOMM_SOURCES
    pango/pangomm/attributes.cc
    pango/pangomm/attriter.cc
    pango/pangomm/attrlist.cc
    pango/pangomm/cairofontmap.cc
    pango/pangomm/color.cc
    pango/pangomm/context.cc
    pango/pangomm/coverage.cc
    pango/pangomm/font.cc
    pango/pangomm/fontdescription.cc
    pango/pangomm/fontface.cc
    pango/pangomm/fontfamily.cc
    pango/pangomm/fontmap.cc
    pango/pangomm/fontmetrics.cc
    pango/pangomm/fontset.cc
    pango/pangomm/glyph.cc
    pango/pangomm/glyphstring.cc
    pango/pangomm/init.cc
    pango/pangomm/item.cc
    pango/pangomm/language.cc
    pango/pangomm/layout.cc
    pango/pangomm/layoutiter.cc
    pango/pangomm/layoutline.cc
    pango/pangomm/layoutrun.cc
    pango/pangomm/rectangle.cc
    pango/pangomm/renderer.cc
    pango/pangomm/tabarray.cc
    pango/pangomm/wrap_init.cc
)

#[[
set(PANGOMM_HEADERS
    pango/pangomm/attributes.h
    pango/pangomm/attriter.h
    pango/pangomm/attrlist.h
    pango/pangomm/cairofontmap.h
    pango/pangomm/color.h
    pango/pangomm/context.h
    pango/pangomm/coverage.h
    pango/pangomm/font.h
    pango/pangomm/fontdescription.h
    pango/pangomm/fontface.h
    pango/pangomm/fontfamily.h
    pango/pangomm/fontmap.h
    pango/pangomm/fontmetrics.h
    pango/pangomm/fontset.h
    pango/pangomm/glyph.h
    pango/pangomm/glyphstring.h
    pango/pangomm/init.h
    pango/pangomm/item.h
    pango/pangomm/language.h
    pango/pangomm/layout.h
    pango/pangomm/layoutiter.h
    pango/pangomm/layoutline.h
    pango/pangomm/layoutrun.h
    pango/pangomm/rectangle.h
    pango/pangomm/renderer.h
    pango/pangomm/tabarray.h
    pango/pangomm/types.h
    pango/pangomm/wrap_init.h
)
#]]

file(GLOB PANGOMM_HEADERS "pango/*.h")
file(GLOB PANGOMM_SUBHEADERS "pango/pangomm/*.h")

add_library(${PANGOMM_TARGET} ${PANGOMM_SOURCES})

set_target_properties(${PANGOMM_TARGET} PROPERTIES
    CXX_STANDARD 11
    CXX_STANDARD_REQUIRED YES
    CXX_EXTENSIONS NO
)

if(BUILD_SHARED_LIBS)
    if (MSVC)
        message("MSVC detected, exporting all symbols from DLL")
        set_target_properties(
            ${PANGOMM_TARGET}
            PROPERTIES WINDOWS_EXPORT_ALL_SYMBOLS true
        )
        #set_target_properties(${GTKMM_TARGET} PROPERTIES DEBUG_POSTFIX d)
    endif()
    #target_compile_definitions(${PANGOMM_TARGET} PRIVATE "PANGOMM_DLL" "PANGOMM_BUILD")
else()
    #target_compile_definitions(${PANGOMM_TARGET} PRIVATE "PANGOMM_STATIC_LIB")
endif()

target_include_directories(${PANGOMM_TARGET} PUBLIC pango ${PANGOMM_DEPS_INCLUDE_DIRS})

target_link_libraries(${PANGOMM_TARGET} PUBLIC ${PANGOMM_DEPS_LIBRARIES})

install(
    TARGETS ${PANGOMM_TARGET}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

install(
    FILES ${PANGOMM_HEADERS}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PANGOMM_TARGET}
)

install(
    FILES ${PANGOMM_SUBHEADERS}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PANGOMM_TARGET}/pangomm
)

install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/pangommconfig.h
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/${PANGOMM_TARGET}/include
)
