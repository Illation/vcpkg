cmake_minimum_required(VERSION 3.4)

set(
    CMAKE_MODULE_PATH
    ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/CMakeScripts
)

include(GtkmmVersion)

project(gtkmm)

# Be consistent with the library names on other platforms
set(GDKMM_TARGET gdkmm-${GDKMM_VERSION_MAJOR}.0)
set(GTKMM_TARGET gtkmm-${GTKMM_VERSION_MAJOR}.0)

option(BUILD_SHARED_LIBS "Build shared Libraries." ON)
option(INSTALL_HEADERS "Install header files." ON)

include(GtkmmDependencies)

configure_file(CMakeScripts/gdkmmconfig.h.in gdkmmconfig.h)
configure_file(CMakeScripts/gtkmmconfig.h.in gtkmmconfig.h)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

include(GtkmmSourceFiles)

add_library(${GDKMM_TARGET} ${GDKMM_SOURCES})

add_library(${GTKMM_TARGET} ${GTKMM_SOURCES})

set_target_properties(${GDKMM_TARGET} PROPERTIES
    CXX_STANDARD 11
    CXX_STANDARD_REQUIRED YES
    CXX_EXTENSIONS NO
)

set_target_properties(${GTKMM_TARGET} PROPERTIES
    CXX_STANDARD 11
    CXX_STANDARD_REQUIRED YES
    CXX_EXTENSIONS NO
)

# avoid warning about inheritance and dominance
if(MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4250")
endif()

if(BUILD_SHARED_LIBS)
    if (MSVC)
        message("MSVC detected, exporting all symbols from DLL")
        set_target_properties(${GDKMM_TARGET} PROPERTIES WINDOWS_EXPORT_ALL_SYMBOLS true)
        set_target_properties(${GTKMM_TARGET} PROPERTIES WINDOWS_EXPORT_ALL_SYMBOLS true)
        #set_target_properties(${GTKMM_TARGET} PROPERTIES DEBUG_POSTFIX d)
        set(CMAKE_DEBUG_POSTFIX d)
    endif()
    # define anything for gdkmm?
    target_compile_definitions(${GTKMM_TARGET} PRIVATE "GTKMM_DLL" "GTKMM_BUILD" "_WINDLL")
else()
    target_compile_definitions(${GTKMM_TARGET} PRIVATE "GTKMM_STATIC_LIB")
endif()

target_include_directories(${GDKMM_TARGET} PUBLIC gdk ${GDKMM_REQUIRED_INCLUDE_DIRS})
target_include_directories(${GTKMM_TARGET} PUBLIC gtk)

target_link_libraries(${GDKMM_TARGET} PRIVATE ${CAIRO_LIBRARY} ${GDKMM_REQUIRED_LIBRARIES})
target_link_libraries(${GTKMM_TARGET} PRIVATE ${CAIRO_LIBRARY} ${GTKMM_REQUIRED_LIBRARIES} ${GDKMM_REQUIRED_LIBRARIES})


# TODO demo

include (GtkmmInstall)
