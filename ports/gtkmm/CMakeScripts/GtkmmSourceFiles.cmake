file(GLOB GDKMM_SOURCES "gdk/gdkmm/*.cc")

file(GLOB GTKMM_SOURCES "gtk/gtkmm/*.cc")

file(GLOB GTKMM_WINDOWS_EXCLUDE_SOURCES
    "gtk/gtkmm/pagesetupunixdialog.cc"
    "gtk/gtkmm/plug.cc"
    "gtk/gtkmm/printer.cc"
    "gtk/gtkmm/printjob.cc"
    "gtk/gtkmm/printunixdialog.cc"
    "gtk/gtkmm/socket.cc"
)

list(REMOVE_ITEM GTKMM_SOURCES ${GTKMM_WINDOWS_EXCLUDE_SOURCES})

file(GLOB GDKMM_HEADERS "gdk/*.h")
file(GLOB GTKMM_HEADERS "gtk/*.h")
file(GLOB GDKMM_SUBHEADERS "gdk/gdkmm/*.h")
file(GLOB GTKMM_SUBHEADERS "gtk/gtkmm/*.h")
