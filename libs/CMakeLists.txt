cmake_minimum_required(VERSION 3.14)

# List to store QML import paths
set(QML_IMPORT_PATHS "")

# Find Qt5
find_package(Qt5Core REQUIRED)
# Get the path to qmake
get_target_property(QMAKE_EXECUTABLE Qt5::qmake IMPORTED_LOCATION)

# This function parse all sub-folders to find CMake module or .pro file
file(GLOB subDirectories RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *)
foreach(dir ${subDirectories})
    if(IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${dir}")
        if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${dir}/CMakeLists.txt")
            # Insert CMAKE project
            add_subdirectory(${dir})

            list(APPEND DEPS_LIBS_INCS ${CMAKE_CURRENT_SOURCE_DIR}/${dir}/include)
            list(APPEND DEPS_LIBS ${dir})

            message(DEBUG "Found CMake Libraries sub-directory: ${dir}")
        elseif(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${dir}/${dir}.pro")
            # Insert QMAKE project
            set(QMAKE_PROJECT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/${dir}")
            set(QMAKE_BINARY_DIR "${CMAKE_BINARY_DIR}/${dir}_build")

            # Create a target to build QMake project
            add_custom_target(${dir}_qmake ALL
                COMMAND ${CMAKE_COMMAND} -E make_directory ${QMAKE_BINARY_DIR}
                COMMAND ${CMAKE_COMMAND} -E chdir ${QMAKE_BINARY_DIR} ${QMAKE_EXECUTABLE} ${QMAKE_PROJECT_DIR}/${dir}.pro
                COMMAND ${CMAKE_COMMAND} -E chdir ${QMAKE_BINARY_DIR} make
                COMMENT "Building QMake project: ${dir}"
            )

            list(APPEND DEPS_LIBS_INCS ${CMAKE_CURRENT_SOURCE_DIR}/${dir}/include)
            list(APPEND DEPS_LIBS ${dir})
            list(APPEND DEPS_LIBS_QMAKE ${dir}_qmake)

            message(DEBUG "Found QMake Libraries sub-directory: ${dir}")

            # Check if it is a QML module
            if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${dir}/qmldir")
                list(APPEND QML_IMPORT_PATHS "${CMAKE_CURRENT_SOURCE_DIR}/${dir}")
            endif()
        endif()
    endif()
endforeach(dir)

# We created a global variable available from the root project
set(DEPS_LIBS_INCS ${DEPS_LIBS_INCS} PARENT_SCOPE)
set(DEPS_LIBS ${DEPS_LIBS} PARENT_SCOPE)
set(DEPS_LIBS_QMAKE ${DEPS_LIBS_QMAKE} PARENT_SCOPE)
set(QML_IMPORT_PATHS ${QML_IMPORT_PATHS} PARENT_SCOPE)

#message(DEBUG "DEPS_LIBS_INCS: ${DEPS_LIBS_INCS}")
