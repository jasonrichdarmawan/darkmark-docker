This README is not related to darkmark-docker repository.

# Installation

Requirements:
1. Ubuntu 20.04

1. Install CUDA Toolkit 12.0 Update 1

Reference:
1. https://developer.nvidia.com/cuda-toolkit-archive
2. https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#post-installation-actions
```
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.0.1/local_installers/cuda-repo-ubuntu2004-12-0-local_12.0.1-525.85.12-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-12-0-local_12.0.1-525.85.12-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2004-12-0-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda

export PATH=/usr/local/cuda-12.0/bin$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-12.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
echo -e "export PATH=/usr/local/cuda-12.0/bin:$PATH\nexport LD_LIBRARY_PATH=/usr/local/cuda-12.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> ~/.bashrc

sudo systemctl enable nvidia-persistenced
sudo cp /lib/udev/rules.d/40-vm-hotadd.rules /etc/udev/rules.d
sudo sed -i '/SUBSYSTEM=="memory", ACTION=="add"/d' /etc/udev/rules.d/40-vm-hotadd.rules
```

2. Install cuDNN v8.8.0 (February 7th, 2023) for CUDA 12.0

Reference:
1. https://docs.nvidia.com/deeplearning/cudnn/install-guide/index.html#installlinux-deb
```
wget https://developer.download.nvidia.com/compute/redist/cudnn/v8.8.0/local_installers/12.0/cudnn-local-repo-ubuntu2004-8.8.0.121_1.0-1_amd64.deb
sudo dpkg -i cudnn-local-repo-ubuntu2004-8.8.0.121_1.0-1_amd64.deb
sudo cp /var/cudnn-local-repo-*/cudnn-local-*-keyring.gpg /usr/share/keyrings/
sudo apt-get install libcudnn8=8.8.0.121-1+cuda12.0
sudo apt-get install libcudnn8-dev=8.8.0.121-1+cuda12.0
sudo apt-get install libcudnn8-samples=8.8.0.121-1+cuda12.0
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

If you use NVIDIA T4, run this command
```
sed -i '0,/# ARCH= -gencode arch=compute_75,code=\[sm_75,compute_75\]/s//ARCH= -gencode arch=compute_75,code=\[sm_75,compute_75\]/' Makefile
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

1. yolov4-tiny
**Google Cloud Platform**
Architecture: x86_64
GPUs: 1x NVIDIA T4
Machine type: n1-standard-1 (1vCPU, 3.75 GB memory)
Image: ubuntu-2004-focal-v20230125
Boot disk type: SSD persistent disk (Size 50 GB)

**DarkMark**
darknet configuration template: yolov4-tiny.cfg
network dimension: 416x416
batch size: 64
subdivisions: 1
max_batches: 6000