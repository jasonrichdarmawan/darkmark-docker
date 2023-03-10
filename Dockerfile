# syntax=docker/dockerfile:1
FROM ubuntu:20.04

# Install Darknet
ENV TZ="Asia/Jakarta"
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes build-essential git libopencv-dev
WORKDIR /home/nonroot
RUN git clone https://github.com/AlexeyAB/darknet.git
WORKDIR /home/nonroot/darknet
# Makefile configuration
# for more information 
# see https://www.ccoderun.ca/programming/darknet_faq/#how_to_build_on_linux
RUN sed -i '0,/OPENCV=0/s//OPENCV=1/; 0,/OPENMP=0/s//OPENMP=1/; 0,/LIBSO=0/s//LIBSO=1/' Makefile && \
    # uncomment if run in Intel CPU
    # sed -i '0,/AVX=0/s//AVX=1/' Makefile && \
    make && \
    cp libdarknet.so /usr/local/lib/ && \
    cp include/darknet.h /usr/local/include/ && \
    ldconfig

# if you wish to train YOLOv4-tiny in the docker container
RUN apt-get --yes install time

# Install DarkHelp
RUN apt-get install --yes cmake build-essential libtclap-dev libmagic-dev libopencv-dev
WORKDIR /home/nonroot
RUN git clone https://github.com/stephanecharette/DarkHelp.git
WORKDIR /home/nonroot/DarkHelp/build
RUN cmake -DCMAKE_BUILD_TYPe=Release .. && \
    make && \
    make package && \
    dpkg -i darkhelp*.deb

# Install DarkMask
RUN apt-get install --yes build-essential cmake libopencv-dev libx11-dev libfreetype6-dev libxrandr-dev libxinerama-dev libxcursor-dev libmagic-dev libpoppler-cpp-dev fonts-liberation
WORKDIR /home/nonroot
RUN git clone https://github.com/stephanecharette/DarkMark.git
WORKDIR /home/nonroot/DarkMark/src-darkmark
# fix: keyboard without numeric keypad combine '+' and '=' into 1 key. the drawback is that keyboard can't input '+' without the 'SHIFT' key 
RUN sed -i "0,/keychar == '+'/s//keychar == '+' || keychar == '='/" DMContent.cpp
WORKDIR /home/nonroot/DarkMark/build
RUN cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make && \
    make package && \
    dpkg -i darkmark*.deb

# Create non-root user
RUN useradd nonroot
USER nonroot
WORKDIR /home/nonroot

# To connect to the X11 Server (on the host machine).
ENV DISPLAY=host.docker.internal:0.0

CMD ["/bin/bash"]