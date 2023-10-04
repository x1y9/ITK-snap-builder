cmake_minimum_required(VERSION 3.1...3.27)

project(
        ITK-Snap-SuperBuild
        VERSION 1.0
        LANGUAGES CXX)

include(FetchContent)

#execute_process(COMMAND git clone  --recurse-submodules https://github.com/alexsodt/ITK-SNAP-Burgess-Sodt.git WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
#execute_process(COMMAND git checkout f5a08b5 WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/ITK-SNAP-Burgess-Sodt/)
#execute_process(COMMAND git submodule update --init --recursive WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/ITK-SNAP-Burgess-Sodt/)
#execute_process(COMMAND git clone https://github.com/pyushkevich/c3d.git WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/ITK-SNAP-Burgess-Sodt/Submodules)
#execute_process(COMMAND git checkout 6775632 WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/ITK-SNAP-Burgess-Sodt/Submodules/c3d)

FetchContent_Declare(
        ITK_fetch
        GIT_REPOSITORY https://github.com/InsightSoftwareConsortium/ITK.git
        GIT_TAG v4.13.3
)

FetchContent_Declare(
        VTK_fetch
        GIT_REPOSITORY https://gitlab.kitware.com/vtk/vtk.git
        GIT_TAG v8.1.2
)


set(OpenGL_GL_PREFERENCE GLVND)

#set build options for vtk
set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
set(BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
set(VTK_GROUP_ENABLE_Qt ON CACHE BOOL "" FORCE)
set(VTK_MODULE_ENABLE_VTK_GUISupportQtQuick OFF CACHE BOOL "" FORCE)
set(VTK_MODULE_ENABLE_VTK_GUISupportQtSQL OFF CACHE BOOL "" FORCE)

#set build options for itk
set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
set(BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
set(Module_MorphologicalContourInterpolation ON CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(VTK_fetch ITK_fetch)

add_custom_target(clone-and-patch
    COMMAND rm -rf ${CMAKE_BINARY_DIR}/ITK-SNAP-Burgess-Sodt
    COMMAND bash ${PROJECT_SOURCE_DIR}/clone-and-patch.sh
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Cloning and checking out repositories"
)

add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/ITK-SNAP-Burgess-Sodt/build/CMakeCache.txt
    COMMAND patch -u ${CMAKE_BINARY_DIR}/ITK-SNAP-Burgess-Sodt/CMakeLists.txt ${PROJECT_SOURCE_DIR}/tinyxml-include.patch
    COMMAND mkdir -p ${CMAKE_BINARY_DIR}/ITK-SNAP-Burgess-Sodt/build
    COMMAND ${CMAKE_COMMAND} -DITK_DIR=${itk_fetch_BINARY_DIR} -DVTK_DIR=${vtk_fetch_BINARY_DIR} ${CMAKE_BINARY_DIR}/ITK-SNAP-Burgess-Sodt
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/ITK-SNAP-Burgess-Sodt/build
    COMMENT "Configuring ITKSNAP"
    DEPENDS clone-and-patch
)

add_custom_target(itksnap ALL
    COMMAND ${CMAKE_COMMAND} --build . --config Release -j ${nproc}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/ITK-SNAP-Burgess-Sodt/build
    COMMENT "Building ITKSNAP"
    DEPENDS ${CMAKE_BINARY_DIR}/ITK-SNAP-Burgess-Sodt/build/CMakeCache.txt
    DEPENDS VTK
    DEPENDS ITK
)

