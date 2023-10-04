#!/usr/bin/env bash

# Enable strict error checking
set -euo pipefail

# Function to check if a command is available and exit with an error message if not
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "Error: $1 is not installed. Please install $1."
        exit 1
    fi
}

# Check for the presence of required tools
check_command git
check_command patch

git clone --recurse-submodules https://github.com/alexsodt/ITK-SNAP-Burgess-Sodt.git
cd ITK-SNAP-Burgess-Sodt
git checkout f5a08b5
git submodule update --init --recursive

# Apply the patch to CMakeLists.txt to fix tinyxml header includes
patch -u CMakeLists.txt ../../tinyxml-include.patch

# Change to the Submodules directory
cd Submodules

# Clone the missing c3d repository and check out a specific commit
git clone https://github.com/pyushkevich/c3d.git
cd c3d
git checkout 6775632
