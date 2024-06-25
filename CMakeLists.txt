cmake_minimum_required(VERSION 3.18)

set(CMAKE_MESSAGE_LOG_LEVEL "DEBUG")	#STATUS|VERBOSE|DEBUG|TRACE

# ========================================================
# GLOBAL VARIABLES
# ========================================================
set(PROJECT_OUTPUT "${CMAKE_CURRENT_SOURCE_DIR}/bin")
set(PROJECT_ROOT ${CMAKE_CURRENT_SOURCE_DIR})
set(BUILD_MACROS_CMAKE_FILE ${PROJECT_ROOT}/build_macros.cmake)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_OUTPUT})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_OUTPUT})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_OUTPUT})

set(LIBS_SUBDIR libs)
set(LIB_BIN_DIR "${PROJECT_OUTPUT}")
set(LIB_OBJ_DIR "${LIBS_SUBDIR}")
set(LIB_PRJ_DIR ${PROJECT_ROOT}/${LIBS_SUBDIR})


set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fuse-ld=gold -Wno-unused-command-line-argument")

include(${BUILD_MACROS_CMAKE_FILE})
cmake_constants()

# ========================================================
# PROJECTS
# ========================================================
get_filename_component(PROJECT_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
set(PROJECT_VERS "0.0.1")
project(${PROJECT_NAME} LANGUAGES ${PROJECT_LANG} VERSION ${PROJECT_VERS} DESCRIPTION "Proof of concept project")


# Get the current working branch
execute_process(
    COMMAND git rev-parse --abbrev-ref HEAD
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_BRANCH
    OUTPUT_STRIP_TRAILING_WHITESPACE)

# Get the latest commit hash
execute_process(
    COMMAND git rev-parse HEAD
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_COMMIT_HASH
    OUTPUT_STRIP_TRAILING_WHITESPACE)


# Include the libraries
add_subdirectory(${LIB_PRJ_DIR} ${LIB_OBJ_DIR})

# Include the include directories and libraries defined in libs
include_directories(${DEPS_LIBS_INCS})

# Set QML_IMPORT_PATH environment variable
set(QML_IMPORT_PATH "${QML_IMPORT_PATHS}" CACHE STRING "Path to QML modules")
add_compile_definitions(QML_IMPORT_PATH="${QML_IMPORT_PATH}")
message(NOTICE "++++ All QML Import path: ${QML_IMPORT_PATH}")

message(NOTICE "==> DEPENDS LIBS in root are ${DEPS_LIBS}.")
message(NOTICE "==> DEPENDS LIBS QMAKE in root are ${DEPS_LIBS_QMAKE}.")

#include the application project
add_subdirectory(app)


