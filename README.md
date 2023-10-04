# ITK-snap-builder

This project provides a shim cmake project to build the ITK-SNAP fork https://github.com/alexsodt/ITK-SNAP-Burgess-Sodt

It utilizes [CPM](https://github.com/cpm-cmake/CPM.cmake/tree/master) to build the ITK and VTK projects at specific commits.

A small patch is applied to the ITK-SNAP-Burgess-Sodt to fix the tinyxml header location in the project's CMakeLists.txt.


## Build instructions

### Rocky 8:
```
dnf install gcc-c++ libglvnd-devel python3 libXt-devel qt5-qtbase-devel qt5-qtdeclarative-devel libcurl-devel mesa-libGLU-devel

git clone https://github.com/bsandbro/ITK-snap-builder.git
cd ITK-snap-builder
mkdir build
cd build
cmake ..
make
make itksnap
cd ITK-SNAP-Burgess-Sodt/build
make install
```
