rm -rf build

conan install . --output-folder=build --build=missing

cd build/build/generators

cmake ../../.. -G "Visual Studio 17" -DCMAKE_TOOLCHAIN_FILE="conan_toolchain.cmake"

cmake --build . --config Release