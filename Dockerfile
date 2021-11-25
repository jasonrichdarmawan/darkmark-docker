# syntax=docker/dockerfile:1
FROM ubuntu:20.04
ENV TZ="America/Los Angeles"


RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get install --yes dbus-x11 python3 wget g++ make build-essential git libx11-dev python3-dbus  libopencv-dev cmake libtclap-dev libmagic-dev libfreetype6-dev libxrandr-dev libxinerama-dev libxcursor-dev xpra
RUN wget -q https://xpra.org/gpg.asc -O- | apt-key add -


WORKDIR /app
RUN git clone https://github.com/AlexeyAB/darknet.git
WORKDIR /app/darknet
RUN sed -i 's/LIBSO=0/LIBSO=1/g' Makefile && \ 
    make && \ 
    cp libdarknet.so /usr/local/lib/ && \ 
    cp include/darknet.h /usr/local/include/ && \ 
    ldconfig
WORKDIR /app
RUN git clone https://github.com/stephanecharette/DarkHelp.git; mkdir /app/DarkHelp/build
WORKDIR /app/DarkHelp/build
RUN cmake -DCMAKE_BUILD_TYPE=Release .. && \ 
    make && \ 
    make package && \ 
    dpkg -i darkhelp*.deb

WORKDIR /app
RUN git clone https://github.com/stephanecharette/DarkMark.git; mkdir /app/DarkMark/build
WORKDIR /app/DarkMark/build
RUN cmake -DCMAKE_BUILD_TYPE=Release .. && \ 
    make && \ 
    make package && \ 
    dpkg -i darkmark*.deb

RUN adduser --disabled-password --gecos "VICE_User" --uid 1000 user && \ 
    mkdir -p /run/user/1000/xpra && \ 
    mkdir -p /run/xpra 

RUN git clone https://github.com/Xpra-org/xpra-html5
RUN cd xpra-html5 && \
    ./setup.py install /usr/share/xpra/www && \
    chown user:user /run/user/1000/xpra && \ 
    chown user:user /run/xpra 


USER user
ENV DISPLAY=:100
WORKDIR /home/user
EXPOSE 9876


COPY ./dataset /home/user/dataset
COPY ./weights /home/user/weights
COPY ./cfg /home/user/cfg

CMD /usr/bin/xpra start :100 --start-child=DarkMark --bind-tcp=0.0.0.0:9876 --daemon=no --exit-with-children
