cmake_minimum_required(VERSION 3.1...3.27)

project(
        ITK-Snap-SuperBuild
        VERSION 1.0
        LANGUAGES CXX)

include(cmake/CPM.cmake)

set(OpenGL_GL_PREFERENCE GLVND) 
Set(FETCHCONTENT_QUIET FALSE)

CPMAddPackage(
    NAME ITK
    GIT_REPOSITORY https://github.com/InsightSoftwareConsortium/ITK.git
    GIT_TAG v5.2.1
    GIT_PROGRESS TRUE
    OPTIONS
    "BUILD_TESTING OFF" 
    "BUILD_EXAMPLES OFF" 
    "BUILD_SHARED_LIBS OFF" 
    "Module_MorphologicalContourInterpolation ON"
    "OpenGL_GL_PREFERENCE GLVND"

)

CPMAddPackage(
    NAME VTK
    GIT_REPOSITORY https://github.com/Kitware/VTK.git
    GIT_TAG v9.1.0
    GIT_PROGRESS TRUE
    OPTIONS
    "BUILD_TESTING OFF" 
    "BUILD_EXAMPLES OFF" 
    "BUILD_SHARED_LIBS OFF" 
    "VTK_GROUP_ENABLE_Qt ON"
    "VTK_MODULE_ENABLE_VTK_GUISupportQtQuick OFF"
    "VTK_MODULE_ENABLE_VTK_GUISupportQtSQL OFF"
    "OpenGL_GL_PREFERENCE GLVND"
)


add_custom_target(clone-and-patch
    COMMAND rm -rf ${CMAKE_BINARY_DIR}/itksnap
    COMMAND ${PROJECT_SOURCE_DIR}/clone-and-patch.bat
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Cloning and checking out repositories"
)

add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/itksnap/build/CMakeCache.txt
    COMMAND ${CMAKE_COMMAND} -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE -DITK_DIR=${ITK_BINARY_DIR} -DVTK_DIR=${VTK_BINARY_DIR} -DOpenGL_GL_PREFERENCE=GLVND ${CMAKE_BINARY_DIR}/itksnap
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/itksnap/build
    COMMENT "Configuring ITKSNAP"
    DEPENDS clone-and-patch
)

add_custom_target(itksnap
    COMMAND ${CMAKE_COMMAND} --build . --config Release -j ${nproc}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/itksnap/build
    COMMENT "Building ITKSNAP"
    DEPENDS ${CMAKE_BINARY_DIR}/itksnap/build/CMakeCache.txt
)

