This README is not related to darkmark-docker repository.

# Installation

Requirements:
1. Ubuntu 20.04

1. Install CUDA Toolkit 11.7.1 (August 2022)

Reference:
1. https://developer.nvidia.com/cuda-toolkit-archive
2. https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#post-installation-actions
```
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.7.1/local_installers/cuda-repo-ubuntu2004-11-7-local_11.7.1-515.65.01-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-11-7-local_11.7.1-515.65.01-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2004-11-7-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda

export PATH=/usr/local/cuda-11.7/bin$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-11.7/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
echo -e "export PATH=/usr/local/cuda-11.7/bin:$PATH\nexport LD_LIBRARY_PATH=/usr/local/cuda-11.7/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> ~/.bashrc
sudo systemctl enable nvidia-persistenced
sudo cp /lib/udev/rules.d/40-vm-hotadd.rules /etc/udev/rules.d
sudo sed -i '/SUBSYSTEM=="memory", ACTION=="add"/d' /etc/udev/rules.d/40-vm-hotadd.rules

sudo reboot now
```

**Reboot now**
Otherwise, you will get error when building darknet
```
(instance) $ make
chmod +x *.sh
g++ -std=c++11 -std=c++11 -Iinclude/ -I3rdparty/stb/include -DOPENCV `pkg-config --cflags opencv4 2> /dev/null || pkg-config --cflags opencv` -DGPU -I/usr/local/cuda/include/ -DCUDNN -DCUDNN_HALF -Wall -Wfatal-errors -Wno-unused-result -Wno-unknown-pragmas -fPIC -Ofast -DOPENCV -fopenmp -DGPU -DCUDNN -I/usr/local/cudnn/include -DCUDNN_HALF -fPIC -c ./src/image_opencv.cpp -o obj/image_opencv.o
In file included from ./src/image.h:3,
                 from ./src/image_opencv.h:4,
                 from ./src/image_opencv.cpp:1:
include/darknet.h:46:10: fatal error: cudnn.h: No such file or directory
   46 | #include <cudnn.h>
      |          ^~~~~~~~~
compilation terminated.
make: *** [Makefile:182: obj/image_opencv.o] Error 1
```

2. Install cuDNN v8.4.1 (May 27th, 2022) for CUDA 11.6

Reference:
1. https://docs.nvidia.com/deeplearning/cudnn/install-guide/index.html#installlinux-deb
```
wget https://developer.download.nvidia.com/compute/redist/cudnn/v8.4.1/local_installers/11.6/cudnn-local-repo-ubuntu2004-8.4.1.50_1.0-1_amd64.deb
sudo dpkg -i cudnn-local-repo-ubuntu2004-8.4.1.50_1.0-1_amd64.deb
sudo cp /var/cudnn-local-repo-*/cudnn-local-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get install libcudnn8=8.4.1.50-1+cuda11.6

sudo apt-get install libcudnn8-dev=8.4.1.50-1+cuda11.6
```

3. Install darknet
```
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install --yes build-essential git libopencv-dev

git clone https://github.com/AlexeyAB/darknet.git
cd darknet
sed -i '0,/OPENCV=0/s//OPENCV=1/; 0,/OPENMP=0/s//OPENMP=1/; 0,/LIBSO=0/s//LIBSO=1/' Makefile
sed -i '0,/GPU=0/s//GPU=1/; 0,/CUDNN=0/s//CUDNN=1/' Makefile
sed -i '0,/CUDNN_HALF=0/s//CUDNN_HALF=1/' Makefile
```

**If you use NVIDIA T4, run this command**
```
sed -i '0,/# ARCH= -gencode arch=compute_75,code=\[sm_75,compute_75\]/s//ARCH= -gencode arch=compute_75,code=\[sm_75,compute_75\]/' Makefile
```

**If you use NVIDIA Tesla V100, run this command**
```
sed -i '0,/# ARCH= -gencode arch=compute_70,code=\[sm_70,compute_70\]/s//ARCH= -gencode arch=compute_70,code=\[sm_70,compute_70\]/' Makefile
```

Build
```
make
sudo cp libdarknet.so /usr/local/lib/
sudo cp include/darknet.h /usr/local/include/
sudo ldconfig
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

1. yolov4-tiny network 416x416
**Google Cloud Platform**
Architecture: x86_64
GPUs: 1x NVIDIA T4
Machine type: n1-standard-1 (1 vCPU, 3.75 GB memory)
Image: ubuntu-2004-focal-v20230125
Boot disk type: SSD persistent disk (Size 50 GB)

**DarkMark**
darknet configuration template: yolov4-tiny.cfg
network dimension: 416x416
batch size: 64
subdivisions: 1
max_batches: 6000

2. yolov4-tiny-3l 608x608
**Google Cloud Platform**
Architecture: x86_64
GPUs: 1x NVIDIA T4
Machine type: n1-standard-2 (2 vCPU, 7.5 GB memory)
Image: ubuntu-2004-focal-v20230213
Boot disk type: SSD persistent disk (Size 50 GB)

**DarkMark**
darknet configuration template: yolov4-tiny-3l.cfg
network dimension: 608x608
batch size: 64
subdivisions: 2
max_batches: 20000

Note: with n1-standard-1 (1 vCPU, 3.75 GB memory), darknet will experience CPU bottleneck.

Elapsed time (h:mm:ss): 9:36:28

3. yolov4-tiny-3l 608x608
**Google Cloud Platform**
Architecture: x86_64
GPUs: 1x NVIDIA T4
Machine type: n1-standard-8 (8 vCPU, 30 GB memory)
Image: ubuntu-2004-focal-v20230213
Boot disk type: SSD persistent disk (Size 50 GB)

**DarkMark**
darknet configuration template: yolov4-tiny-3l.cfg
network dimension: 608x608
batch size: 64
subdivisions: 2
max_batches: 20000

Elapsed time (h:mm:ss): 7:22:55

4. yolov4-tiny-3l 608x608
**Google Cloud Platform**
Architecture: x86_64
GPUs: 1x NVIDIA V100
Machine type: n1-standard-4 (4 vCPU, 15 GB memory)
Image: ubuntu-2004-focal-v20230213
Boot disk type: SSD persistent disk (Size 50 GB)

**DarkMark**
darknet configuration template: yolov4-tiny-3l.cfg
network dimension: 608x608
batch size: 64
subdivisions: 2
max_batches: 20000

Elapsed time (h:mm:ss): 3:55:02

# Known Issues

1. Error at 1000 iterations

The error
```
 (next mAP calculation at 1000 iterations)
 1000: 0.187699, 0.292302 avg loss, 0.002610 rate, 1.940648 seconds, 64000 images, 11.678495 hours left
4Darknet error location: ./src/dark_cuda.c, cudnn_check_error, line #204
cuDNN Error: CUDNN_STATUS_BAD_PARAM: Success

 calculation mAP (mean average precision)...
 Detection layer: 30 - type = 28
 Detection layer: 37 - type = 28
 Detection layer: 44 - type = 28

 cuDNN status Error in: file: ./src/convolutional_kernels.cu : () : line: 543 : build time: Feb 15 2023 - 19:55:11

 cuDNN Error: CUDNN_STATUS_BAD_PARAM
Command exited with non-zero status 1
        Command being timed: "/home/jason_onggo/darknet/darknet detector -map -dont_show train /home/jason_onggo/shared/M017C071/M017C071.data /home/jason_onggo/shared/M017C071/M017C071.cfg"
        User time (seconds): 3040.40
        System time (seconds): 359.52
        Percent of CPU this job got: 153%
        Elapsed (wall clock) time (h:mm:ss or m:ss): 36:56.10
        Average shared text size (kbytes): 0
        Average unshared data size (kbytes): 0
        Average stack size (kbytes): 0
        Average total size (kbytes): 0
        Maximum resident set size (kbytes): 3855352
        Average resident set size (kbytes): 0
        Major (requiring I/O) page faults: 1
        Minor (reclaiming a frame) page faults: 60457699
        Voluntary context switches: 2085089
        Involuntary context switches: 1922119
        Swaps: 0
        File system inputs: 96
        File system outputs: 433656
        Socket messages sent: 0
        Socket messages received: 0
        Signals delivered: 0
        Page size (bytes): 4096
        Exit status: 1
```

**The libraries**
CUDA Toolkit 12.0 Update 1 (January 2023)
cuDNN v8.8.0 (February 7th, 2023) for CUDA 12.0

The solution is to downgrade CUDA Toolkit to v11.7.1 and cuDNN to v8.4.1