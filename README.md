# What is DarkMark?

> DarkMark is a C++ GUI tool used to annotate images for use in neural networks. It was written specifically to be used with the Darknet neural network framework, and has several features tailored for use with Darknet and YOLO.

Go to the [DarkMark official repository](https://github.com/stephanecharette/DarkMark)

# How to Build DarMark in Docker

## Test using xeyes.

xeyes is a simple X11 application to test if a Docker container can forward GUI to the host machine.

1. Install X11 Server i.e. for macOS, install XQuartz. Start the X11 Server.
2. Allow host names from which X11 server accepts connections. For macOS, run the command below in the host machine terminal `$ xhost +127.0.0.1`
3. Try to open xeyes by running the command below in the host machine terminal:

```
docker build -t xeyes -f Dockerfile.xeyes .
docker run --rm xeyes
```

## Test using DarkMark

1. Start the X11 Server.
2. `$ xhost +127.0.0.1` in the host machine terminal.
3. Create a folder named `shared` in this repository. Use this folder for storing the neural network file, dataset, weights that will be used by DarkMark.
4. Edit the `Dockerfile` file, i.e. set to `AVX=1` in Makefile if you run the Docker image with Intel CPU.

Reference:
1. from the `darknet/Makefile` file
```
# set GPU=1 and CUDNN=1 to speedup on GPU
# set CUDNN_HALF=1 to further speedup 3 x times (Mixed-precision on Tensor Cores) GPU: Volta, Xavier, Turing and higher
# set AVX=1 and OPENMP=1 to speedup on CPU (if error occurs then set AVX=0)
# set ZED_CAMERA=1 to enable ZED SDK 3.0 and above
# set ZED_CAMERA_v2_8=1 to enable ZED SDK 2.X
```

5. Try to open DarkMark.

Build the Docker image
```
docker build -t darkmark -f Dockerfile .
docker run -it --rm -v $PWD/shared:/home/nonroot/shared --name darkmark darkmark
```

Open the DarkMark, run this command in the docker container.
```
(nonroot) $ DarkMark
```

If you have never use DarkMark before, watch these tutorial:
1. [install darknet, DarkHelp, DarkMark and train](https://www.youtube.com/watch?v=RcLL8Lea6Ec)
2. [create darknet files](https://www.youtube.com/watch?v=8Ms9T9Ue2g8)

# Tested Environment

1. Apple M1, Docker Desktop v4.12.0 (85629)

# Known Issues

1. If the xhost list is not persistent, every time you reboot, you will get this error (see the top of the error message)
```
(nonroot) $ DarkMark
Authorization required, but no authorization protocol specified
```

The solution is to make the xhost list persistent, by running the command below in the host machine terminal.
```
$ sudo bash -c 'echo 127.0.0.1 >> /etc/X0.hosts'
```

2. If you click on the `Load` button, the window will change to a window for annotating images. If you click the exit button (at the top left or right of the window), the window returns to the main menu in the minimized window.

minimized window

![minimized window](./readme_images/minimized_window.png)

The solution is to drag the 3 line strip to the right.

# Notable References

1. [How to increase FPS](https://www.ccoderun.ca/programming/darknet_faq/#fps)
2. [YOLOv3 FPS results with Jetson devices](https://www.ccoderun.ca/programming/2021-10-16_darknet_fps/#resize)
3. [YOLO to detect small object](https://www.youtube.com/watch?v=861LvUXvJmA)
4. [YOLOv4 and YOLOv4-tiny comparison](https://www.youtube.com/watch?v=gPP6fh8IIAo&t=184s)