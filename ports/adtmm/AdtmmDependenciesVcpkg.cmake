# We only really need one include path for vcpkg as there is only one
find_path(FMT_INCLUDE_DIRS fmt/format.h)
find_path(ADT_INCLUDE_DIRS adt.hpp)
find_path(GTKMM_INCLUDE_DIRS gtkmm.h)

set(ADTMM_DEPS_INCLUDE_DIRS
    ${FMT_INCLUDE_DIRS}
    ${ADT_INCLUDE_DIRS}
    ${GTKMM_INCLUDE_DIRS}
)

# We don't need the define the whole stack,
# just the libraries we directly reference
find_library(FMT_LIBRARIES fmt)
find_library(ADT_LIBRARIES adt-0)
find_library(GLIB_LIBRARIES glib-2.0)
find_library(GLIBMM_LIBRARIES glibmm)
find_library(GTK_LIBRARIES gtk-3.0)
find_library(SICG_LIBRARIES sigc-2.0)
find_library(ATKMM_LIBRARIES atkmm-1.6)
find_library(GIOMM_LIBRARIES giomm)
find_library(GTKMM_LIBRARIES gtkmm-3.0)

set(ADTMM_DEPS_LIBRARIES
    ${FMT_LIBRARIES}
    ${ADT_LIBRARIES}
    ${GLIB_LIBRARIES}
    ${GTK_LIBRARIES}
    ${SICG_LIBRARIES}
    ${GLIBMM_LIBRARIES}
    ${ATKMM_LIBRARIES}
    ${GTKMM_LIBRARIES}
)
