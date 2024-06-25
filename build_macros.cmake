
macro(cmake_constants)
    cmake_minimum_required(VERSION 3.18)

    set(CMAKE_MESSAGE_LOG_LEVEL "VERBOSE")	#STATUS|VERBOSE|DEBUG|TRACE

    set(CMAKE_INCLUDE_CURRENT_DIR ON)
    set(CMAKE_VERBOSE_MAKEFILE ON)
    set(CMAKE_CXX_STANDARD 17)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)

    set(PROJECT_LANG C CXX)

    set(QT_COM_MODULES
        Core
        Qml
        Quick
    )
    set(QT_ADD_MODULES "")

    set(PROJ_DEPENDS "")
    set(PROJ_DEP_INCS "")

    set(CMAKE_AUTOUIC ON)
    set(CMAKE_AUTOMOC ON)
    set(CMAKE_AUTORCC ON)

    set(GENERAL_INCLUDE_FOLDER ${PROJECT_ROOT}/include)
    include_directories(${GENERAL_INCLUDE_FOLDER})
    #	this is only to see the general header files in the projects
    file(GLOB GENERAL_HEADER_FILES "${GENERAL_INCLUDE_FOLDER}/*.h")
endmacro()



macro(findQtComModule)
    if(NOT "${QT_COM_MODULES}" STREQUAL "")
        find_package(QT NAMES Qt6 Qt5 COMPONENTS ${QT_COM_MODULES} REQUIRED)
        find_package(Qt${QT_VERSION_MAJOR} COMPONENTS ${QT_COM_MODULES} REQUIRED)
    endif()
    if(NOT "${QT_ADD_MODULES}" STREQUAL "")
        find_package(QT NAMES Qt6 Qt5 COMPONENTS ${QT_ADD_MODULES} REQUIRED)
        find_package(Qt${QT_VERSION_MAJOR} COMPONENTS ${QT_ADD_MODULES} REQUIRED)
    endif()
endmacro()



macro(addQtModule moduleName)
    list(APPEND QT_ADD_MODULES ${moduleName})
endmacro()



macro(delQtModule moduleName)
    list(REMOVE_ITEM QT_ADD_MODULES ${moduleName})
endmacro()



macro(includeQtModule)
    if(NOT "${QT_COM_MODULES}" STREQUAL "")
        foreach(module IN LISTS QT_COM_MODULES)
            target_link_libraries(${PROJECT_NAME} PRIVATE Qt${QT_VERSION_MAJOR}::${module})
        endforeach()
    endif()
    if(NOT "${QT_ADD_MODULES}" STREQUAL "")
        find_package(QT NAMES Qt6 Qt5 COMPONENTS ${QT_ADD_MODULES} REQUIRED)
        find_package(Qt${QT_VERSION_MAJOR} COMPONENTS ${QT_ADD_MODULES} REQUIRED)
        foreach(module IN LISTS QT_ADD_MODULES)
            target_link_libraries(${PROJECT_NAME} PRIVATE Qt${QT_VERSION_MAJOR}::${module})
        endforeach()
    endif()
endmacro()



macro(addStateChart chartPath chartName)
    if(NOT "${chartName}" STREQUAL "")
        if("${chartPath}" STREQUAL "")
            set(filename ${chartName}.scxml)
        else()
            set(filename ${chartPath}/${chartName}.scxml)
        endif()
        list(APPEND STATE_CHARTS ${filename})
        set_source_files_properties(${chartName}.h PROPERTIES SKIP_AUTOMOC TRUE)
        message(VERBOSE "State chart '${filename}' defined for project '${PROJECT_NAME}'")
    endif()
endmacro()



macro(setProject version description)
    get_filename_component(PROJECT_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
    set(PROJECT_VERS ${version})
    project(${PROJECT_NAME} LANGUAGES ${PROJECT_LANG} VERSION ${PROJECT_VERS} DESCRIPTION ${description})

    set(PROJECT_INC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include ${CMAKE_CURRENT_SOURCE_DIR}/source)
    include_directories(${PROJECT_INC_DIR})
endmacro()



macro(dependency dep_name)
    if(IS_DIRECTORY "${LIB_PRJ_DIR}/${dep_name}")
        if(EXISTS "${LIB_PRJ_DIR}/${dep_name}/CMakeLists.txt")
            set(${dep_name}_DIR ${CMAKE_BINARY_DIR}/${dep_name})
            #find_package(${dep_name} CONFIG)
            list(APPEND PROJ_DEPENDS ${dep_name})
            list(APPEND PROJ_DEP_INCS  ${LIB_PRJ_DIR}/${dep_name}/include)
        elseif(EXISTS "${LIB_PRJ_DIR}/${dep_name}/${dep_name}.pro")
            set(${dep_name}_DIR "${CMAKE_BINARY_DIR}/${dep_name}_build")
            list(APPEND PROJ_DEPENDS_QMAKE ${dep_name}_qmake)
            list(APPEND PROJ_DEPENDS ${dep_name})
            list(APPEND PROJ_DEP_INCS  ${LIB_PRJ_DIR}/${dep_name}/include)
        else()
            message(FATAL_ERROR "ERROR : Dependency library '${dep_name}' of project '${PROJECT_NAME}' is not a valid libraries subdirectory")
        endif()
    else()
        message(FATAL_ERROR "ERROR : Dependency library '${dep_name}' of project '${PROJECT_NAME}' does not exists")
    endif()
endmacro()



macro(addLinkLibrary libName)
    list(APPEND DEPS_LIBS ${libName})
endmacro()



macro(composeBuildFiles)
    findQtComModule()
    if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
        if(NOT "${STATE_CHARTS}" STREQUAL "")
            # Process your *.scsml files with Qt SCXML Compiler (qscxmlc)
            qt6_add_statecharts(QT_SCXML_COMPILED ${STATE_CHARTS})
        endif()
        if(NOT "${PROJECT_RESOURCE}" STREQUAL "")
            qt_add_resources(RC_SRC ${PROJECT_RESOURCE})
        endif()
    else()
        if(NOT "${STATE_CHARTS}" STREQUAL "")
            # Process your *.scsml files with Qt SCXML Compiler (qscxmlc)
            qt5_add_statecharts(QT_SCXML_COMPILED ${STATE_CHARTS})
        endif()
        if(NOT "${PROJECT_RESOURCE}" STREQUAL "")
            qt5_add_resources(RC_SRC ${PROJECT_RESOURCE})
        endif()
    endif()
    set(BUILD_FILES
        ${PROJECT_INTERFACES}
        ${PROJECT_HEADERS}
        ${PROJECT_SOURCES}
        ${RC_SRC}
        ${GENERAL_HEADER_FILES}
        ${QT_SCXML_COMPILED}
    )
endmacro()



macro(configureLinkAndInstall)
    message(DEBUG "'${PROJECT_NAME}' INCS : ${DEPS_LIBS_INCS}")
    target_include_directories(${PROJECT_NAME} PUBLIC ${DEPS_LIBS_INCS})
    target_link_directories(${PROJECT_NAME} PUBLIC ${PROJECT_OUTPUT})

    if (NOT "${PROJ_DEPENDS_QMAKE}" STREQUAL "")
        message(VERBOSE "QMAKE DEPENDS for project '${PROJECT_NAME}' : ${PROJ_DEPENDS}")
        add_dependencies(${PROJECT_NAME} ${PROJ_DEPENDS_QMAKE})
    endif()
    if(NOT "${PROJ_DEPENDS}" STREQUAL "")
        message(VERBOSE "DEPENDS for project '${PROJECT_NAME}' : ${PROJ_DEPENDS}")
        target_link_libraries(${PROJECT_NAME} PRIVATE ${PROJ_DEPENDS})
    endif()
    target_include_directories(${PROJECT_NAME} PUBLIC ${PROJ_DEP_INCS} ${PROJECT_INC_DIR})

    includeQtModule()

    # Install application
    install(TARGETS ${PROJECT_NAME} DESTINATION ${PROJECT_OUTPUT}/${PROJECT_NAME})
endmacro()





macro(headerApp)
    cmake_constants()

    findQtComModule()
endmacro()



macro(footerApp)
    composeBuildFiles()

    if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
        qt_add_executable(${PROJECT_NAME} ${BUILD_FILES})
    else()
        add_executable(${PROJECT_NAME} ${BUILD_FILES})
    endif()

    target_compile_definitions(${PROJECT_NAME} PUBLIC $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

    target_compile_definitions(${PROJECT_NAME} PRIVATE "-DGIT_COMMIT_HASH=\"${GIT_COMMIT_HASH}\"")

    message(VERBOSE "'${PROJECT_NAME}' LIBS : ${DEPS_LIBS}")
    target_link_libraries(${PROJECT_NAME} PUBLIC ${DEPS_LIBS})

    configureLinkAndInstall()
endmacro()




macro(headerLib)
    cmake_constants()

    findQtComModule()
endmacro()



macro(footerLib)
    composeBuildFiles()

    add_library(${PROJECT_NAME} SHARED ${BUILD_FILES})

    configureLinkAndInstall()
endmacro()




macro(headerPlg)
    cmake_constants()

    findQtComModule()
endmacro()



macro(footerPlg)
    composeBuildFiles()

    add_library(${PROJECT_NAME} SHARED ${BUILD_FILES})

    configureLinkAndInstall()
endmacro()
