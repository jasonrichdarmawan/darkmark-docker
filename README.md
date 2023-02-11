# What is DarkMark?

> DarkMark is a C++ GUI tool used to annotate images for use in neural networks. It was written specifically to be used with the Darknet neural network framework, and has several features tailored for use with Darknet and YOLO.

Go to the [DarkMark official repository](https://github.com/stephanecharette/DarkMark)

# How to Build DarMark in Docker

## Test using xeyes.

xeyes is a simple X11 application to test if a Docker container can forward GUI to the host machine.

1. Install X11 Server i.e. for macOS, install XQuartz. Start the X11 Server.
2. Allow host names from which X11 server accepts connections `$ xhost +127.0.0.1`
3. Try to open xeyes by running the command below in the terminal:

```
$ docker build -t xeyes -f Dockerfile.xeyes .
$ docker run --rm xeyes
```

## Test using DarkMark

1. Start the X11 Server.
2. `$ xhost +127.0.0.1`
3. Try to open DarkMark.

```
$ docker build -t darkmark -f Dockerfile.new .
$ docker run --name darkmark darkmark
```

# Tested Environment

1. Apple M1, Docker Desktop v4.12.0 (85629)