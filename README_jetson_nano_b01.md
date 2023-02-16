This README is not related to darkmark-docker repository.

# Installation

1. Install darknet

Reference:
1. https://www.ccoderun.ca/programming/darknet_faq/#how_to_build_on_linux
```
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install --yes build-essential git libopencv-dev
git clone https://github.com/AlexeyAB/darknet.git
cd darknet
sed -i '0,/OPENCV=0/s//OPENCV=1/; 0,/OPENMP=0/s//OPENMP=1/; 0,/LIBSO=0/s//LIBSO=1/' Makefile
sed -i '0,/GPU=0/s//GPU=1/; 0,/CUDNN=0/s//CUDNN=1/' Makefile
sed -i '0,/CUDNN_HALF=0/s//CUDNN_HALF=1/' Makefile
sed -i '0,/# ARCH= -gencode arch=compute_53,code=\[sm_53,compute_53\]/s//ARCH= -gencode arch=compute_53,code=\[sm_53,compute_53\]/' Makefile
echo -e "export PATH=/usr/local/cuda/bin:$PATH\nexport LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> ~/.bashrc
source ~/.bashrc
make
sudo cp libdarknet.so /usr/local/lib/
sudo cp include/darknet.h /usr/local/include/
sudo ldconfig
```

2. Install time
```
sudo apt-get --yes install time
```

3. Install DarkHelp
```
sudo apt-get install --yes cmake build-essential libtclap-dev libmagic-dev libopencv-dev
cd ~
git clone https://github.com/stephanecharette/DarkHelp.git
cd DarkHelp
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPe=Release ..
make
make package
sudo dpkg -i darkhelp*.deb
```

4. Install DarkMark
```
sudo apt-get install --yes build-essential cmake libopencv-dev libx11-dev libfreetype6-dev libxrandr-dev libxinerama-dev libxcursor-dev libmagic-dev libpoppler-cpp-dev fonts-liberation
cd ~
git clone https://github.com/stephanecharette/DarkMark.git
cd DarkMark
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make
make package
sudo dpkg -i darkmark*.deb
```

# Tested Environment

1. NVIDIA Jetson Nano B01 4GB RAM, Image: NVIDIA Jetpack SDK 4.6.1
**DarkMark**
darknet configuration template: yolov4-tiny.cfg
network dimension: 256x256
batch size: 1
subdivisions: 1
max_batches: 4000

Elapsed time (h:mm:ss): 4:17:49

2. NVIDIA Jetson Nano B01 4GB RAM, Image: NVIDIA Jetpack SDK 4.6.1
**DarkMark**
darknet configuration template: yolov4-tiny-3l.cfg
network dimension: 256x256
batch size: 64
subdivisions: 1
max_batches: 8000

Elapsed time (h:mm:ss): 8:28:36

# Known Issues

1. If you set `CUDNN=1` in the `~/darknet/Makefile`, and if you try to install darknet in NVIDIA Jetson Nano B01, you will get this error message.
```
nvcc -gencode arch=compute_35,code=sm_35 -gencode arch=compute_50,code=[sm_50,compute_50] -gencode arch=compute_52,code=[sm_52,compute_52] -gencode arch=compute_61,code=[sm_61,compute_61] -Iinclude/ -I3rdparty/stb/include -DOPENCV `pkg-config --cflags opencv4 2> /dev/null || pkg-config --cflags opencv` -DGPU -I/usr/local/cuda/include/ -DCUDNN --compiler-options "-Wall -Wfatal-errors -Wno-unused-result -Wno-unknown-pragmas -fPIC -Ofast -DOPENCV -fopenmp -DGPU -DCUDNN -I/usr/local/cudnn/include -fPIC" -c ./src/convolutional_kernels.cu -o obj/convolutional_kernels.o
/bin/sh: 1: nvcc: not found
Makefile:185: recipe for target 'obj/convolutional_kernels.o' failed
make: *** [obj/convolutional_kernels.o] Error 127
```

The solution is to run this command in the NVIDIA Jetson Nano B01 terminal
```
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
```

Then, set the `ARCH` variable in the `~/darknet/Makefile` by running this command in the terminal
```
echo "ARCH= -gencode arch=compute_53,code=[sm_53,compute_53]" >> ~/darknet/Makefile
```

2. If you train in NVIDIA Jetson Nano B01, you will get this error message.

```
stop_sign_train.sh: line 20: /usr/bin/time: No such file or directory
```

The solution is to run this command in the terminal
```
sudo apt-get --yes install time
```

3. If you annotate image and generate the darknet files on different machine i.e. a Docker container. Then, you try to train the model on different machine i.e. NVIDIA Jetson Nano B01, you will get this error message.

```
stop_sign_train.sh: line 3: cd: /home/nonroot/shared/stop_sign: No such file or directory
find: ‘/home/nonroot/shared/stop_sign’: No such file or directory
```

The solution is to change the `/home/nonroot` to the NVIDIA Jetson Nano B01 current user home directory i.e. `/home/tempatkerja-01` by running this command in the terminal.

```
sed -i "s|/home/nonroot|$HOME|g" stop_sign_train.sh
sed -i "s|/home/nonroot|$HOME|g" stop_sign.data
sed -i "s|/home/nonroot|$HOME|g" stop_sign_train.txt
sed -i "s|/home/nonroot|$HOME|g" stop_sign_valid.txt
```