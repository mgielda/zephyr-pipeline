#!/bin/bash

git submodule update --init
cd zephyr
source zephyr-env.sh
cd ../application
mkdir build
cd build
cmake -DBOARD=m2gl025_miv ..
make -j$(nproc)
cp zephyr/zephyr.elf ../../artifacts
make
cd ../../
/opt/renode/tests/test.sh -r artifacts zephyr.robot
