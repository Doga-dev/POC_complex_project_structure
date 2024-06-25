# ========================================================
# CMake configuration
# ========================================================
include(${BUILD_MACROS_CMAKE_FILE})
headerApp()

# ========================================================
# Project specific
# ========================================================
setProject("0.0.2" "Proof of concept application")


dependency(graphics)


set(PROJECT_INTERFACES
)
set(PROJECT_HEADERS
)
set(PROJECT_SOURCES
    main.cpp
)

set(RC_SRC
    gui/gui.qrc
)

# ========================================================
# Footer
# ========================================================
footerApp()
