
include(GnuInstallDirs)

install(
    TARGETS ${GDKMM_TARGET} ${GTKMM_TARGET}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/gdkmmconfig.h
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/${GDKMM_TARGET}/include
)

install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/gtkmmconfig.h
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/${GTKMM_TARGET}/include
)

install(
    FILES ${GDKMM_HEADERS}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${GDKMM_TARGET}
)

install(
    FILES ${GDKMM_SUBHEADERS}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${GDKMM_TARGET}/gdkmm
)

install(
    FILES ${GTKMM_HEADERS}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${GTKMM_TARGET}
)

install(
    FILES ${GTKMM_SUBHEADERS}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${GTKMM_TARGET}/gtkmm
)
