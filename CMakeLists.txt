cmake_minimum_required(VERSION 3.1...3.27)

project(
        ITK-Snap-SuperBuild
        VERSION 1.0
        LANGUAGES CXX)

include(cmake/CPM.cmake)

set(OpenGL_GL_PREFERENCE GLVND) 

CPMAddPackage(
    NAME ITK
    GIT_REPOSITORY https://github.com/InsightSoftwareConsortium/ITK.git
    GIT_TAG v4.13.3
    OPTIONS
    "BUILD_TESTING OFF" 
    "BUILD_EXAMPLES OFF" 
    "BUILD_SHARED_LIBS OFF" 
    "Module_MorphologicalContourInterpolation ON"
    "OpenGL_GL_PREFERENCE GLVND"

)

CPMAddPackage(
    NAME VTK
    GIT_REPOSITORY https://gitlab.kitware.com/vtk/vtk.git
    GIT_TAG v8.1.2
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
    COMMAND rm -rf ${CMAKE_BINARY_DIR}/ITK-SNAP-Burgess-Sodt
    COMMAND bash ${PROJECT_SOURCE_DIR}/clone-and-patch.sh
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Cloning and checking out repositories"
)

add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/ITK-SNAP-Burgess-Sodt/build/CMakeCache.txt
    COMMAND ${CMAKE_COMMAND} -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE -DITK_DIR=${ITK_BINARY_DIR} -DVTK_DIR=${VTK_BINARY_DIR} -DOpenGL_GL_PREFERENCE=GLVND ${CMAKE_BINARY_DIR}/ITK-SNAP-Burgess-Sodt
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/ITK-SNAP-Burgess-Sodt/build
    COMMENT "Configuring ITKSNAP"
    DEPENDS clone-and-patch
)

add_custom_target(itksnap
    COMMAND ${CMAKE_COMMAND} --build . --config Release -j ${nproc}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/ITK-SNAP-Burgess-Sodt/build
    COMMENT "Building ITKSNAP"
    DEPENDS ${CMAKE_BINARY_DIR}/ITK-SNAP-Burgess-Sodt/build/CMakeCache.txt
)

