# We only really need one include path for vcpkg as there is only one
find_path(GTK_INCLUDE_DIRS glib.h)

set(GDKMM_REQUIRED_INCLUDE_DIRS
    ${GTK_INCLUDE_DIRS}
)

find_library(GLIB_LIBRARIES glib-2.0)
find_library(GOBJECT_LIBRARIES gobject-2.0)
find_library(GTHREAD_LIBRARIES gthread-2.0)
find_library(GMODULE_LIBRARIES gmodule-2.0)
find_library(GDK_LIBRARIES gdk-3.0)
find_library(GDK_PIXBUF_LIBRARIES gdk_pixbuf-2.0)
find_library(GTK_LIBRARIES gtk-3.0)
find_library(SIGC_LIBRARIES sigc-2.0)
find_library(GIOMM_LIBRARIES giomm)
find_library(GLIBMM_LIBRARIES glibmm)
find_library(CAIRO_LIBRARIES cairo)
find_library(CAIROMM_LIBRARIES cairomm-1.0)
find_library(PANGOMM_LIBRARIES pangomm)

set(GDKMM_REQUIRED_LIBRARIES
    ${GLIB_LIBRARIES}
    ${GOBJECT_LIBRARIES}
    ${GTHREAD_LIBRARIES}
    ${GMODULE_LIBRARIES}
    ${GDK_LIBRARIES}
    ${GDK_PIXBUF_LIBRARIES}
    ${GTK_LIBRARIES}
    ${SIGC_LIBRARIES}
    ${GIOMM_LIBRARIES}
    ${GLIBMM_LIBRARIES}
    ${CAIRO_LIBRARIES}
    ${CAIROMM_LIBRARIES}
    ${PANGOMM_LIBRARIES}
)

set(GTKMM_REQUIRED_LIBRARIES
    ${GDKMM_TARGET}
)
